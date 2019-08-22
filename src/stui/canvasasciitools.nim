import stui/ui_canvas
#https://lodev.org/cgtutor/floodfill.html
proc floodInkScanline*(layer:ImageLayer, x,y:int, newColor, oldColor: Brush):void=
  ## x,y in layer coords!
  if newColor.fgColor == oldColor.fgColor and
    newColor.bgColor == oldColor.bgColor
  : return
  var
    cx = x
    cy = y
    cright, cleft:int
  # draw current scanline from start position to the right
  while cx < layer.w and
    layer.fgColor[y][cx] == oldColor.fgColor and
    layer.bgColor[y][cx] == oldColor.bgColor:
      layer.fgColor[y][cx] = newColor.fgColor
      layer.bgColor[y][cx] = newColor.bgColor
    
      cx += 1
  cright = cx - 1
  if cright < 0: cright = 0

  # draw current scanline from start position to the left
  cx = x - 1
  while cx >= 0 and
    layer.fgColor[y][cx] == oldColor.fgColor and
    layer.bgColor[y][cx] == oldColor.bgColor:
      layer.fgColor[y][cx] = newColor.fgColor
      layer.bgColor[y][cx] = newColor.bgColor
    
      cx -= 1
  cleft = cx + 1
  if cleft < 0: cleft = 0
  
  # test for new scanlines above
  cy = y - 1
  if cy >= 0:
    cx = x
    # right
    while cx <= cright#[ < layer.w and
      layer.fgColor[y][cx] == newColor.fgColor and
      layer.bgColor[y][cx] == newColor.bgColor ]#
    :
          if layer.fgColor[cy][cx] == oldColor.fgColor and
            layer.bgColor[cy][cx] == oldColor.bgColor:
              floodInkScanline(layer, cx,cy, newColor, oldColor)
          cx.inc
    # left
    cx = x - 1
    while cx >= cleft #[ cx >= 0 and
      layer.fgColor[y][cx] == newColor.fgColor and
      layer.bgColor[y][cx] == newColor.bgColor ]#
    :
          if layer.fgColor[cy][cx] == oldColor.fgColor and
            layer.bgColor[cy][cx] == oldColor.bgColor:
              floodInkScanline(layer, cx,cy, newColor, oldColor)
          cx.dec

  # test for new scanlines below
  cy = y + 1
  if cy < layer.h:
    cx = x
    # right
    while cx <= cright#[ < layer.w and
      layer.fgColor[y][cx] == newColor.fgColor and
      layer.bgColor[y][cx] == newColor.bgColor]#
    :
          if layer.fgColor[cy][cx] == oldColor.fgColor and
            layer.bgColor[cy][cx] == oldColor.bgColor:
              floodInkScanline(layer, cx,cy, newColor, oldColor)
          cx.inc
    # left
    cx = x - 1
    while cx >= cleft #[ cx >= 0 and
      layer.fgColor[y][cx] == newColor.fgColor and
      layer.bgColor[y][cx] == newColor.bgColor ]#
    :
          if layer.fgColor[cy][cx] == oldColor.fgColor and
            layer.bgColor[cy][cx] == oldColor.bgColor:
              floodInkScanline(layer, cx,cy, newColor, oldColor)
          cx.dec













#https://lodev.org/cgtutor/floodfill.html
proc floodFillScanline*(layer:AsciiImageLayer, x,y:int, newColor, oldColor: Brush):void=
  ## x,y in layer coords!
  if newColor.rune == oldColor.rune and
    newColor.fgColor == oldColor.fgColor and
    newColor.bgColor == oldColor.bgColor
  : return
  var
    cx = x
    cy = y
    cright, cleft:int
  # draw current scanline from start position to the right
  while cx < layer.w and
    layer.runes[y][cx] == oldColor.rune[0] and
    layer.fgColor[y][cx] == oldColor.fgColor and
    layer.bgColor[y][cx] == oldColor.bgColor:
      layer.runes[y][cx] = newColor.rune[0]
      layer.fgColor[y][cx] = newColor.fgColor
      layer.bgColor[y][cx] = newColor.bgColor
    
      cx += 1
  cright = cx - 1
  if cright < 0: cright = 0

  # draw current scanline from start position to the left
  cx = x - 1
  while cx >= 0 and
    layer.runes[y][cx] == oldColor.rune[0] and
    layer.fgColor[y][cx] == oldColor.fgColor and
    layer.bgColor[y][cx] == oldColor.bgColor:
      layer.runes[y][cx] = newColor.rune[0]
      layer.fgColor[y][cx] = newColor.fgColor
      layer.bgColor[y][cx] = newColor.bgColor
    
      cx -= 1
  cleft = cx + 1
  if cleft < 0: cleft = 0

  # test for new scanlines above
  cy = y - 1
  if cy >= 0:
    cx = x
    # right
    while cx <= cright #[ and #< layer.w and
      layer.runes[y][cx] == newColor.rune[0] and
      layer.fgColor[y][cx] == newColor.fgColor and
      layer.bgColor[y][cx] == newColor.bgColor ]#
    :
          if layer.runes[cy][cx] == oldColor.rune[0] and
            layer.fgColor[cy][cx] == oldColor.fgColor and
            layer.bgColor[cy][cx] == oldColor.bgColor:
              floodFillScanline(layer, cx,cy, newColor, oldColor)
          cx.inc
    # left
    cx = x - 1
    if cx >= 0:
      while cx >= cleft #[ and #>= 0 and
        layer.runes[y][cx] == newColor.rune[0] and
        layer.fgColor[y][cx] == newColor.fgColor and
        layer.bgColor[y][cx] == newColor.bgColor ]#
      :
            if layer.runes[cy][cx] == oldColor.rune[0] and
              layer.fgColor[cy][cx] == oldColor.fgColor and
              layer.bgColor[cy][cx] == oldColor.bgColor:
                floodFillScanline(layer, cx,cy, newColor, oldColor)
            cx.dec

  # test for new scanlines below
  cy = y + 1
  if cy < layer.h:
    cx = x
    # right
    while cx <= cright #[ and #< layer.w and
      layer.runes[y][cx] == newColor.rune[0] and
      layer.fgColor[y][cx] == newColor.fgColor and
      layer.bgColor[y][cx] == newColor.bgColor ]#
    :
          if layer.runes[cy][cx] == oldColor.rune[0] and
            layer.fgColor[cy][cx] == oldColor.fgColor and
            layer.bgColor[cy][cx] == oldColor.bgColor:
              floodFillScanline(layer, x,cy, newColor, oldColor)
          cx.inc
    # left
    cx = x - 1
    if cx >= 0:
      while cx >= cleft #[ and #>= 0 and
        layer.runes[y][cx] == newColor.rune[0] and
        layer.fgColor[y][cx] == newColor.fgColor and
        layer.bgColor[y][cx] == newColor.bgColor ]#
      :
            if layer.runes[cy][cx] == oldColor.rune[0] and
              layer.fgColor[cy][cx] == oldColor.fgColor and
              layer.bgColor[cy][cx] == oldColor.bgColor:
                floodFillScanline(layer, cx,cy, newColor, oldColor)
            cx.dec
            