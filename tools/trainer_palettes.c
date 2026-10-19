#define PROGRAM_NAME "trainer_palettes"
#define USAGE_OPTS "[-h|--help] [-r|--reverse] [-a|--palette-a N] [-v|--verbose] in.png [out.gbcpal out.allpals]\n" \
	"       " PROGRAM_NAME " --palx [-r|--reverse] [-a|--palette-a N] in.png in.rgbgfxmap out.palx"

// Picks up to 3 BG palettes for a 56x56 trainer pic, each white + 2 colors + black, so that every
// 8x8 tile's colors are all in one palette. Palettes may share colors.
//
// out.gbcpal:  palette A (4 colors), the same format tools/gbcpal writes, for TrainerPalettes
// out.allpals: every palette used (A, then B, then C), for rgbgfx --colors gbc:
//
// --palx runs after rgbgfx, whose palette map (-q) is the one the tile data was made with. It checks
// that every tile's colors are in the palette rgbgfx gave it, and writes out.palx: palette B's and
// C's middle colors (4 bytes each; copies of A when unused), then that map: 2 bits per tile
// (0 = A, 1 = B, 2 = C), in --columns tile order, 4 tiles per byte, first tile in the high bits
// (13 bytes).
//
// With only in.png, it checks the pic and prints a report (make check_trainer_art).

#include "common.h"
#include "lodepng/lodepng.h"

#define PIC_TILES 7
#define NUM_TILES (PIC_TILES * PIC_TILES)
#define MAX_PALS 3
#define MAX_COLORS (MAX_PALS * 2)
#define MAP_SIZE ((NUM_TILES * 2 + 7) / 8)

bool reverse, verbose, palx_mode;
int palette_a_override; // 1-based palette number, or 0

void parse_args(int argc, char *argv[]) {
	struct option long_options[] = {
		{"reverse", no_argument, 0, 'r'},
		{"palette-a", required_argument, 0, 'a'},
		{"verbose", no_argument, 0, 'v'},
		{"palx", no_argument, 0, 'x'},
		{"help", no_argument, 0, 'h'},
		{0}
	};
	for (int opt; (opt = getopt_long(argc, argv, "ra:vxh", long_options)) != -1;) {
		switch (opt) {
		case 'r':
			reverse = true;
			break;
		case 'a':
			palette_a_override = atoi(optarg);
			if (palette_a_override < 1 || palette_a_override > MAX_PALS) {
				error_exit("--palette-a must be 1 to %d\n", MAX_PALS);
			}
			break;
		case 'v':
			verbose = true;
			break;
		case 'x':
			palx_mode = true;
			break;
		case 'h':
			usage_exit(0);
			break;
		default:
			usage_exit(1);
		}
	}
}

struct Color {
	uint8_t r, g, b;
};

const struct Color BLACK = {0, 0, 0};
const struct Color WHITE = {31, 31, 31};

uint16_t pack_color(struct Color color) {
	return (color.b << 10) | (color.g << 5) | color.r;
}

bool same_color(struct Color color1, struct Color color2) {
	return color1.r == color2.r && color1.g == color2.g && color1.b == color2.b;
}

// The same luminance and order as tools/gbcpal, so one-palette pics come out byte-identical
double luminance(struct Color color) {
	return 0.299 * color.r + 0.587 * color.g + 0.114 * color.b;
}

int compare_luminance(const void *color1, const void *color2) {
	double lum1 = luminance(*(const struct Color *)color1);
	double lum2 = luminance(*(const struct Color *)color2);
	// sort lightest to darkest, or darkest to lightest if reversed
	return ((lum1 < lum2) - (lum1 > lum2)) * (reverse ? -1 : 1);
}

const char *png_name;
struct Color colors[256]; // every middle color in the pic, lightest first
int num_colors;
bool inexact_warned;
// per tile: bit i set = uses colors[i]
unsigned tile_colors[NUM_TILES];
bool tile_errors;

// The palettes, as bitmasks of colors[], in order: pals[0] is palette A, etc.
unsigned pals[MAX_PALS];
int num_pals;

const char *tile_pos(int tile, char *buf) {
	// tile is in --columns order
	sprintf(buf, "row %d, col %d", tile % PIC_TILES, tile / PIC_TILES);
	return buf;
}

void print_color(FILE *f, struct Color color) {
	fprintf(f, "(%d,%d,%d)", color.r, color.g, color.b);
}

bool exact_level(unsigned v8) {
	unsigned v5 = v8 >> 3;
	return v8 % 8 == 0 || v8 == ((v5 << 3) | (v5 >> 2));
}

int find_color(struct Color color) {
	for (int i = 0; i < num_colors; i++) {
		if (same_color(colors[i], color)) {
			return i;
		}
	}
	return -1;
}

void read_pic(void) {
	unsigned char *pixels;
	unsigned width, height;
	unsigned err = lodepng_decode32_file(&pixels, &width, &height, png_name);
	if (err) {
		error_exit("%s: %s\n", png_name, lodepng_error_text(err));
	}
	if (width != PIC_TILES * 8 || height != PIC_TILES * 8) {
		error_exit("%s: must be %dx%d, not %ux%u\n", png_name, PIC_TILES * 8, PIC_TILES * 8, width, height);
	}

	// First pass: collect the middle colors
	struct Color found[256];
	int num_found = 0;
	for (unsigned i = 0; i < width * height; i++) {
		unsigned char *p = &pixels[i * 4];
		if (p[3] != 255) {
			error_exit("%s: has transparent pixels (x %u, y %u)\n", png_name, i % width, i / width);
		}
		if (verbose && !inexact_warned && (!exact_level(p[0]) || !exact_level(p[1]) || !exact_level(p[2]))) {
			printf("Warning: #%02X%02X%02X (x %u, y %u) isn't an exact GBC level; it's rounded down\n",
				p[0], p[1], p[2], i % width, i / width);
			inexact_warned = true;
		}
		struct Color color = {p[0] >> 3, p[1] >> 3, p[2] >> 3};
		if (same_color(color, WHITE) || same_color(color, BLACK)) {
			continue;
		}
		bool seen = false;
		for (int j = 0; j < num_found; j++) {
			if (same_color(found[j], color)) {
				seen = true;
				break;
			}
		}
		if (!seen && num_found < 256) {
			found[num_found++] = color;
		}
	}
	qsort(found, num_found, sizeof(*found), compare_luminance);
	memcpy(colors, found, num_found * sizeof(*found));
	num_colors = num_found;

	// Second pass: each tile's colors, in --columns order
	for (int tile = 0; tile < NUM_TILES; tile++) {
		int tx = tile / PIC_TILES, ty = tile % PIC_TILES;
		unsigned used = 0;
		for (int y = 0; y < 8; y++) {
			for (int x = 0; x < 8; x++) {
				unsigned char *p = &pixels[((ty * 8 + y) * width + tx * 8 + x) * 4];
				struct Color color = {p[0] >> 3, p[1] >> 3, p[2] >> 3};
				int i = find_color(color);
				if (i >= 0 && i < 32) {
					used |= 1u << i;
				}
			}
		}
		tile_colors[tile] = used;
		int count = __builtin_popcount(used);
		if (count > 2) {
			char buf[32];
			fprintf(stderr, PROGRAM_NAME ": %s: tile at %s has %d colors besides white and black (max 2):", png_name, tile_pos(tile, buf), count);
			for (int i = 0; i < num_colors; i++) {
				if (used & (1u << i)) {
					fputc(' ', stderr);
					print_color(stderr, colors[i]);
				}
			}
			fputc('\n', stderr);
			tile_errors = true;
		}
	}
	free(pixels);
}

// Candidate palettes: every pair of colors, then every single color, in luminance order.
unsigned candidates[MAX_COLORS * MAX_COLORS];
int num_candidates;

bool tiles_covered(const unsigned *chosen, int n) {
	for (int tile = 0; tile < NUM_TILES; tile++) {
		bool fits = !tile_colors[tile];
		for (int k = 0; k < n && !fits; k++) {
			fits = (tile_colors[tile] & ~chosen[k]) == 0;
		}
		if (!fits) {
			return false;
		}
	}
	return true;
}

// Find the first combination (in candidate order) of n candidates that covers every tile.
bool search(unsigned *chosen, int n, int k, int from) {
	if (k == n) {
		return tiles_covered(chosen, n);
	}
	for (int c = from; c < num_candidates; c++) {
		chosen[k] = candidates[c];
		if (search(chosen, n, k + 1, c + 1)) {
			return true;
		}
	}
	return false;
}

void report_no_cover(void) {
	fprintf(stderr, PROGRAM_NAME ": %s: no %d palettes of 2 colors cover every tile's colors.\n", png_name, MAX_PALS);
	fprintf(stderr, "Colors:");
	for (int i = 0; i < num_colors; i++) {
		fprintf(stderr, " %d=", i + 1);
		print_color(stderr, colors[i]);
	}
	fprintf(stderr, "\nTile color combinations (colors by number), and where they are:\n");
	bool done[NUM_TILES] = {false};
	for (int tile = 0; tile < NUM_TILES; tile++) {
		if (done[tile] || !tile_colors[tile]) {
			continue;
		}
		fprintf(stderr, " ");
		for (int i = 0; i < num_colors; i++) {
			if (tile_colors[tile] & (1u << i)) {
				fprintf(stderr, " %d", i + 1);
			}
		}
		fprintf(stderr, ":");
		for (int other = tile; other < NUM_TILES; other++) {
			if (tile_colors[other] == tile_colors[tile]) {
				char buf[32];
				fprintf(stderr, " (%s)", tile_pos(other, buf));
				done[other] = true;
			}
		}
		fputc('\n', stderr);
	}
}

// The index of a palette's first (skip = 0) or second (skip = 1) color, or num_colors if none
int nth_color(unsigned pal, int skip) {
	for (int i = 0; i < num_colors; i++) {
		if (pal & (1u << i) && skip-- == 0) {
			return i;
		}
	}
	return num_colors;
}

int compare_pals(const void *pal1, const void *pal2) {
	unsigned a = *(const unsigned *)pal1, b = *(const unsigned *)pal2;
	int d = nth_color(a, 0) - nth_color(b, 0);
	return d ? d : nth_color(a, 1) - nth_color(b, 1);
}

int tiles_fitting(unsigned pal) {
	int n = 0;
	for (int tile = 0; tile < NUM_TILES; tile++) {
		n += tile_colors[tile] && !(tile_colors[tile] & ~pal);
	}
	return n;
}

void pick_palettes(void) {
	if (num_colors > MAX_COLORS) {
		fprintf(stderr, PROGRAM_NAME ": %s: %d colors besides white and black (max %d):", png_name, num_colors, MAX_COLORS);
		for (int i = 0; i < num_colors; i++) {
			fputc(' ', stderr);
			print_color(stderr, colors[i]);
		}
		fputc('\n', stderr);
		exit(1);
	}
	if (tile_errors) {
		exit(1);
	}

	num_candidates = 0;
	for (int i = 0; i < num_colors; i++) {
		for (int j = i + 1; j < num_colors; j++) {
			candidates[num_candidates++] = (1u << i) | (1u << j);
		}
	}
	for (int i = 0; i < num_colors; i++) {
		candidates[num_candidates++] = 1u << i;
	}

	// Use as few palettes as possible
	unsigned chosen[MAX_PALS] = {0};
	num_pals = 0;
	if (num_colors <= 2) {
		// one palette holds everything (or only white and black)
		chosen[0] = (1u << num_colors) - 1;
		num_pals = 1;
	} else {
		for (int n = 2; n <= MAX_PALS; n++) {
			if (search(chosen, n, 0, 0)) {
				num_pals = n;
				break;
			}
		}
		if (!num_pals) {
			report_no_cover();
			exit(1);
		}
	}

	// Number the palettes by their colors, lightest first (or darkest first if reversed).
	// Palette A is the one the most tiles fit, unless --palette-a names one.
	qsort(chosen, num_pals, sizeof(*chosen), compare_pals);
	int a = 0;
	if (palette_a_override) {
		if (palette_a_override > num_pals) {
			error_exit("%s: --palette-a %d, but the pic has only %d palette%s\n", png_name, palette_a_override, num_pals, num_pals == 1 ? "" : "s");
		}
		a = palette_a_override - 1;
	} else {
		for (int k = 1; k < num_pals; k++) {
			if (tiles_fitting(chosen[k]) > tiles_fitting(chosen[a])) {
				a = k;
			}
		}
	}
	int number[MAX_PALS];
	int n = 0;
	pals[n] = chosen[a];
	number[n++] = a;
	for (int k = 0; k < num_pals; k++) {
		if (k != a) {
			pals[n] = chosen[k];
			number[n++] = k;
		}
	}

	if (verbose) {
		printf("Colors besides white and black (5-bit):");
		for (int i = 0; i < num_colors; i++) {
			printf(" ");
			print_color(stdout, colors[i]);
		}
		printf("\n");
		for (int k = 0; k < num_pals; k++) {
			printf("Palette %c = palette %d:", 'A' + k, number[k] + 1);
			for (int i = 0; i < num_colors; i++) {
				if (pals[k] & (1u << i)) {
					printf(" ");
					print_color(stdout, colors[i]);
				}
			}
			int fit = tiles_fitting(pals[k]);
			printf(" (%d tile%s fit)", fit, fit == 1 ? "" : "s");
			if (k == 0 && num_pals > 1) {
				printf(palette_a_override ? " <- --palette-a" : " <- most tiles");
			}
			printf("\n");
		}
		printf("Tile map (- = white/black only, * = fits more than one palette; rgbgfx picks):\n");
		for (int ty = 0; ty < PIC_TILES; ty++) {
			printf("  ");
			for (int tx = 0; tx < PIC_TILES; tx++) {
				unsigned used = tile_colors[tx * PIC_TILES + ty];
				int fits = 0, which = 0;
				for (int k = 0; k < num_pals; k++) {
					if (!(used & ~pals[k]) && fits++ == 0) {
						which = k;
					}
				}
				putchar(!used ? '-' : fits > 1 ? '*' : 'A' + which);
			}
			printf("\n");
		}
	}
}

// White, then the palette's colors (one color fills both middle slots), then black
void get_palette(unsigned pal, struct Color out[4]) {
	struct Color mid[2];
	int n = 0;
	for (int i = 0; i < num_colors; i++) {
		if (pal & (1u << i)) {
			mid[n++] = colors[i];
		}
	}
	out[0] = WHITE;
	out[1] = n > 0 ? mid[0] : WHITE;
	out[2] = n > 1 ? mid[1] : n > 0 ? mid[0] : BLACK;
	out[3] = BLACK;
}

void put_color(uint8_t *bytes, struct Color color) {
	uint16_t packed = pack_color(color);
	bytes[0] = packed & 0xff;
	bytes[1] = packed >> 8;
}

void write_palettes(const char *gbcpal_name, const char *allpals_name) {
	uint8_t allpals[MAX_PALS * 4 * 2];
	for (int k = 0; k < num_pals; k++) {
		struct Color pal[4];
		get_palette(pals[k], pal);
		for (int i = 0; i < 4; i++) {
			put_color(&allpals[(k * 4 + i) * 2], pal[i]);
		}
	}
	write_u8(gbcpal_name, allpals, 4 * 2);
	write_u8(allpals_name, allpals, num_pals * 4 * 2);
}

void write_palx(const char *map_name, const char *palx_name) {
	long size;
	uint8_t *map = read_u8(map_name, &size);
	if (size != NUM_TILES) {
		error_exit("%s: expected %d tiles, found %ld\n", map_name, NUM_TILES, size);
	}
	bool ok = true;
	for (int tile = 0; tile < NUM_TILES; tile++) {
		char buf[32];
		if (map[tile] >= num_pals) {
			fprintf(stderr, PROGRAM_NAME ": %s: rgbgfx put the tile at %s in palette %d, but there are only %d\n",
				png_name, tile_pos(tile, buf), map[tile], num_pals);
			ok = false;
		} else if (tile_colors[tile] & ~pals[map[tile]]) {
			fprintf(stderr, PROGRAM_NAME ": %s: rgbgfx put the tile at %s in palette %c, which lacks some of its colors\n",
				png_name, tile_pos(tile, buf), 'A' + map[tile]);
			ok = false;
		}
	}
	if (!ok) {
		exit(1);
	}

	uint8_t palx[2 * 2 * 2 + MAP_SIZE] = {0};
	for (int k = 1; k < MAX_PALS; k++) {
		struct Color pal[4];
		get_palette(pals[k < num_pals ? k : 0], pal);
		put_color(&palx[(k - 1) * 4], pal[1]);
		put_color(&palx[(k - 1) * 4 + 2], pal[2]);
	}
	for (int tile = 0; tile < NUM_TILES; tile++) {
		palx[8 + tile / 4] |= map[tile] << (6 - (tile % 4) * 2);
	}
	free(map);
	write_u8(palx_name, palx, sizeof(palx));
}

int main(int argc, char *argv[]) {
	parse_args(argc, argv);

	argc -= optind;
	argv += optind;
	if (palx_mode ? argc != 3 : argc != 1 && argc != 3) {
		usage_exit(1);
	}

	png_name = argv[0];
	read_pic();
	pick_palettes();

	if (palx_mode) {
		write_palx(argv[1], argv[2]);
	} else if (argc == 3) {
		write_palettes(argv[1], argv[2]);
	} else {
		printf("OK\n");
	}
	return 0;
}
