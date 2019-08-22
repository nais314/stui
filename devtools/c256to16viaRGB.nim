import math, strutils, RGBx256table, stui/colors_extra


var
  incr = 51 #17 #51
  #r,g,b:int
  #hslDist:float
  choice: int
  rgb,rgb2, dist: tuple[r,g,b:int]
  found:bool
  #hslDist256, 
  huec:int
  huedivider = 14
  #hueDistance:float
  c256:int


for c256 in 0..255:

      found = false

      rgb = extractRGB(Color256RGB[c256])
      choice = 0

      dist.r = 9999
      dist.g = 9999
      dist.b = 9999

      
      #block SEARCH:
      for d in 0..15:

        rgb2 = extractRGB(Color256RGB[d])

        if ( abs(rgb.r - rgb2.r) <= dist.r and
          abs(rgb.g - rgb2.g) <= dist.g and
          abs(rgb.b - rgb2.b) <= dist.b
          )
          :  
            choice = d
            found = true
            dist.r = abs(rgb.r - rgb2.r)
            dist.g = abs(rgb.g - rgb2.g)
            dist.b = abs(rgb.b - rgb2.b)




      echo found,
        " c256: \e[38;5;" & $int(c256) & "m " & "███ " & $c256 & "\e[0m",
        " choice: \e[38;5;" & $int(choice) & "m " & "███ " & $choice & "\e[0m"