.PHONY: all clean

CC := gcc
CFLAGS := -O3 -flto -std=c17 -Wall -Wextra -pedantic

tools := \
	gbcpal \
	bankends \
	gfx \
	lzcomp \
	make_patch \
	png_dimensions \
	pokemon_animation \
	pokemon_animation_graphics \
	scan_includes \
	stadium \
	trainer_palettes

all: $(tools)
	@:

clean:
	$(RM) $(tools)

lzcomp: CFLAGS += -Wno-strict-overflow -Wno-sign-compare
lzcomp: $(wildcard lz/*.c) $(wildcard lz/*.h)
	$(CC) $(CFLAGS) -o $@ lz/*.c

bankends: bankends.c parsemap.o
	$(CC) $(CFLAGS) -o $@ $^

trainer_palettes: trainer_palettes.c common.h lodepng/lodepng.c lodepng/lodepng.h
	$(CC) $(CFLAGS) -o $@ trainer_palettes.c lodepng/lodepng.c

parsemap.o: parsemap.c parsemap.h
	$(CC) $(CFLAGS) -c $^

%: %.c common.h
	$(CC) $(CFLAGS) -o $@ $<
