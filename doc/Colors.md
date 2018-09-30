see colors_extra.nim, colors256.nim, colorsRGBto256.nim

for now 8 and 16 color modes use the same procs,
256 color and rgb color modes are widely available.

colorsRGBto256.nim makes using default nim/x11 color names
for 256 + rgb color modes available


from nim 0.19
setting colors are handled by ANSI escape sequences,
for GC safety, see: colors_extra.setForegroundColor