# Google Sheets Write-Back Mechanics

Driving Google Sheets through `mcp__claude-in-chrome__*` has several failure modes that
are silent or destructive. Each rule below was learned by hitting the failure.

## Setup

Load the tools in one call:

```
ToolSearch "select:mcp__claude-in-chrome__tabs_context_mcp,mcp__claude-in-chrome__navigate,mcp__claude-in-chrome__computer,mcp__claude-in-chrome__browser_batch"
```

Then `tabs_context_mcp{createIfEmpty:true}`, navigate to the sheet, screenshot.

## Rule 1 — Re-locate the Name Box after every resolution change

Cell navigation goes through the Name Box (upper left, left of the formula bar). Its
coordinates move when the browser window resizes, and the window can resize between
calls without warning.

**Take a screenshot and read the Name Box position from it before the first click of
every batch.** Clicking stale coordinates lands on the toolbar search icon, which opens
the Import File dialog and swallows everything typed afterward. Nothing is written, no
error is raised, and the batch reports success for every action.

If a batch produces no visible change, screenshot immediately and look for an open dialog
before retrying.

## Rule 2 — Tab characters do not move between cells

`computer.type` with `\t` in the string types literal tab whitespace **into the current
cell**. A row written as `"Name\tUrl\tStatus\n"` lands entirely in column A as one string.

Write column by column instead. Navigate to the top cell of a column, then type all its
values separated by `\n`:

```
Name Box -> "E2"  ->  type "Strong\nStretch\nStrong\nSkip\n"
Name Box -> "F2"  ->  type "Strong\nWeak\nMedium\n\n"
```

This is also fewer round trips than writing row by row.

## Rule 3 — Defeat autocomplete on every repeated-prefix value

Sheets autocompletes from other values in the column, and pressing Enter **accepts the
suggestion**. Typing `FDE` under an existing `FDE / Applied AI` silently writes
`FDE / Applied AI`. Typing `Backend` under `Backend / Internal Tools` writes the long one.

For any value that is a prefix of another value in the same column:

```
type "<value>"  ->  key "Delete"  ->  key "Return"
```

`Delete` clears the selected autocompleted suffix. This matters for `Strong` vs
`Stretch`, `Enriched` vs `Enrichment`, and every truncated variant.

Values written in bulk with `\n` are subject to the same problem. Check the result and
repair individual cells with the Delete trick.

## Rule 4 — Dropdowns go through Insert, not right-click

Right-click menu positions shift with the click's x coordinate and flip sides near the
window edge. Use the menu bar, which is fixed:

1. Select the range through the Name Box, e.g. `E2:E18`
2. Click **Insert** in the menu bar
3. Click **Dropdown** in the menu
4. Overwrite `Option 1` and `Option 2` in the side panel, then **Add another item** for
   each remaining value
5. **Done**

In the side panel the first two item fields sit at a fixed offset; each **Add another
item** click moves the button down by one row height. Read the positions from a
screenshot rather than assuming.

Applying a dropdown to a range inside a Table applies it to the whole table column, which
is what you want.

## Rule 5 — Tables extend one column at a time

Typing a header into the cell immediately right of a Table extends the Table by exactly
one column. It does not accept a whole header row at once.

Set headers one at a time: Name Box to `F1`, type the header, Enter. Repeat. Typing a
header then continuing with `\n` writes the rest **downward into that column**, not
across the header row.

## Rule 6 — "Fit to data" is usually wrong

`Resize columns -> Fit to data` sizes to the longest cell, and one long URL will blow a
column out to the width of the screen. Set explicit pixel widths instead:

Right-click the column header -> **Resize column** -> enter a number -> OK.

Working values for this tracker: Title 440, everything else 200.

## Rule 7 — Links go in as HYPERLINK formulas

To make a title clickable while keeping the cell's text readable:

```
=HYPERLINK("<url>","<title>")
```

Type it as a normal value. Sheets auto-inserts the closing paren when `(` is typed; typing
your own `)` moves over it rather than doubling it, so the full formula types cleanly.

Avoid literal `&` and `—` inside the title argument. Write "and" and "-" instead.

## Rule 8 — Verify, then move on

Screenshot after each batch and confirm the values landed where intended. Do not chain
more than about six dependent actions without looking, because a single misplaced click
invalidates every coordinate that follows it in the same batch.

## Rule 9 — Wait after a long type before navigating away

A long multi-line `type` keeps Sheets busy after the tool call returns. Clicking the Name
Box immediately afterwards can land before the sheet is ready: the navigation target is
swallowed, and the **next** type starts from wherever the cursor actually sits.

Observed failure: a `G8` navigation was dropped, and eleven lines of Carries text were
written down column **F** starting at the header row. That overwrote ten Want values and
silently changed the Table column's type from dropdown to number, which then rejected
every valid Want value as "does not match the column type".

Two habits prevent it:

- Put a `wait` of 1 second after the Name Box navigation and 2 seconds after any type
  longer than a few lines.
- Write **one column per batch**, ending the batch with a screenshot. Two long column
  writes chained in one batch is how the above happened.

Recovering from it is more expensive than preventing it: clear the damaged range, confirm
the header text survived, re-apply the dropdown through Insert (the column type does not
revert on its own), then rewrite the values.
