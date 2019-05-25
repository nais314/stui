see colors_extra.nim, colors256.nim, colorsRGBto256.nim

for now 8 and 16 color modes use the same procs,
256 color and rgb color modes are widely available.

colorsRGBto256.nim makes using default nim/x11 color names
for 256 + rgb color modes available - useful for themeing.
see colors.nim stdlib for color names too.


from nim 0.19  
setting colors are handled by ANSI escape sequences,
for GC safety, see: colors_extra.setForegroundColor

if you use the standard 8/16 colors, its appereance will vary depending on the terminal emulator you use :)  
"color modes are backward compatible": on 256 colors terminal you can use 16 color; on RGB you can use every method, even mixed =)  


app.colorMode caches the initial color mode,
so if not changed on the fly, calling getColorMode
is not neccessary.


setForegroundColor/setBackgroundColor are
changing drawing color (...),
changeForegroundColor/changeBackgroundColor are
working on Controll.styles


**Styles**

to spare repeating setMargin("bottom", 1), modify app's styles before creating 
controll instances.

"input" is the default style, suits TextBox and such, background white
"input:inverse" when the foreground color is white - see ProgressBar