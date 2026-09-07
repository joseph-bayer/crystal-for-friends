# Plan: choosing which Pokémon follows you

Status: proposed, nothing implemented.

Press SELECT on a party member to make it your follower, marked in the party menu. Press SELECT on
the one already marked to clear it, so nobody follows.

## How the follower is picked today

`SetFollowerFromParty` calls `GetFirstAliveMon`, which walks the party and takes the first member
with HP above zero, falling back to slot 1. There is no player input anywhere in that path, and no
stored preference — the follower is recomputed from the party every time.

That routine becomes the only place the new choice has to be honoured, which keeps the change
small. Everything downstream — sprite, palette, forms, interactions — already works off whatever
`SetFollowerFromParty` returns.

## The interaction

`PartyMenuSelect` calls `StaticMenuJoypad` and treats anything that is not B or CANCEL as "this mon
was chosen". Two changes:

1. **Let SELECT through.** `PartyMenu2DMenuData` ends with `db 0 ; accepted buttons`, which loads
   into `wMenuJoypadFilter`. Setting it to `PAD_A | PAD_B | PAD_SELECT | PAD_CTRL_PAD` makes the
   menu loop return on SELECT — the same lever `tmhm.asm` already uses.
2. **Branch on it.** `StaticMenuJoypad` returns the button in `a`. On SELECT, toggle the follower
   for `wMenuCursorY - 1`, redraw the markers, and loop rather than returning; on anything else,
   behave as now.

**Scope it to the browse case.** The party menu is reused for picking a mon to give an item to, to
trade, to put in the day-care, and more, all distinguished by `wPartyMenuActionText`. Hijacking
SELECT everywhere would mean pressing it mid-trade quietly changes your follower. It should apply
only when the menu is being browsed normally, which is the same test
`GetPartyMenuQualityIndexes` already makes on the high nibble of that byte.

## Where the choice is stored

This is the real decision, and there are two defensible answers.

### Option A — a saved byte holding the party slot (recommended)

`0` for nobody, `1`–`6` for a slot.

There is a spare byte already inside the saved block, next to `wBikeFlags`
([ram/wram.asm:2890](../ram/wram.asm#L2890): `ds 1 ; cleared along with wBikeFlags`). Using it
means **the save layout does not shift and existing saves keep working**. Adding a new byte
anywhere else in `wGameData` would move everything after it and invalidate them.

The cost is that the slot has to be kept pointing at the right mon:

| Event | What has to happen |
| --- | --- |
| Party reorder (`_SwitchPartyMons`) | Swap the stored slot when it is one of the two |
| Deposit / release to the PC | Clear if it was the stored slot, decrement if it was after it |
| Withdraw | Nothing — new mons land at the end |
| Trade away | Clear if it was the stored slot |
| Day-care deposit | Same as deposit |

Five call sites, and missing one means the wrong mon follows until the player fixes it. That is
visible and harmless, which is the main argument for this option: it cannot corrupt mon data.

### Option B — a bit on the mon's form byte

`MON_FORM` uses `FORM_MASK` (`%00011111`) and `SHINY_MASK` (`%10000000`), so **bits 5 and 6 are
free**. One of them could mean "this is my follower".

This is genuinely tempting: the flag travels with the mon through reordering, deposits and
withdrawals with no fixups at all, and persists in the save with no layout change. Setting it means
clearing it on the other five party members first, which is six iterations.

The risk is that the bit rides along anywhere a form byte is copied wholesale — into the PC, into a
trade, into a bred egg. A traded mon arriving in someone else's game already flagged as their
follower is the kind of bug that is hard to notice and hard to explain. Every *reader* in this tree
already masks correctly (`_LoadOverworldMonIcon`, `CheckShininess`, `GetMonIconPaletteOrder`,
`GetMonNormalOrShinyPalettePointer` all `and FORM_MASK` or `and SHINY_MASK`), so the danger is not
misreading — it is propagation.

**Recommendation: Option A.** Its failure mode is a wrong slot that the player can correct in two
button presses; Option B's is mon data leaving the game with a stray bit set.

## The marker

`PlacePartyMonGender` is the pattern to copy: it walks the party drawing a symbol at
`hlcoord 12, 2`, stepping two rows per mon, skipping eggs. A follower marker is the same routine at
a different column with a different glyph.

It slots in as a new `PARTYMENUQUALITY_*` entry ([data/party_menu_qualities.asm](../data/party_menu_qualities.asm))
added to the default quality list, which means it draws on the browse screen and not on the
trade/day-care variants — the same scoping the SELECT handler wants.

Two things to settle: which column is free at the party menu's width, and what glyph to use. The
cosmetic form symbols in `data/pokemon/cosmetic_form_symbols.asm` are precedent for adding a small
marker character.

## Honouring the choice

`GetFirstAliveMon` becomes roughly:

- no stored slot → return 0, nobody follows;
- stored slot is empty or fainted → return 0;
- otherwise return that mon.

Note what this removes: the current automatic fallback to "first living mon". Once the player is
choosing explicitly, silently substituting a different mon is worse than showing nobody.

## Decisions to make before building

- **Default for a new game.** Slot 1 preserves today's behaviour; 0 means nobody follows until the
  player opts in. Whichever is chosen, existing saves will read the spare byte as **0** and so
  start with no follower — worth knowing before you load an old save and think it broke.
- **Fainted chosen mon.** Suggest it simply does not appear until healed, rather than falling
  through to another mon.
- **Eggs.** They can follow today. Allowing SELECT on an egg is harmless; blocking it is one
  `PartyMenuCheckEgg` call, the same one `PlacePartyMonGender` makes.
- **Deselecting while the follower is on screen.** It should take the Poké Ball recall animation
  that already exists for warps rather than vanishing between frames.

## Size

Small. The interaction is perhaps 30 lines in `PartyMenuSelect`, the marker another 30 modelled on
`PlacePartyMonGender`, the selection rule under 20 in `GetFirstAliveMon`, and the fixups a few
lines each across five call sites. No new data tables, no new graphics beyond one glyph.
