import math, strutils, RGBx256table, stui/colors_extra, HSLtools, HSL256table


proc getForm*(red,green,blue:int):string=
  if red.int == green.int:
    result = "1"
  elif red.int < green.int:
    result = "2"
  else: result = "3"

  if green.int == blue.int:
    result &= "1"
  elif green.int < blue.int:
    result &= "2"
  else: result &= "3"  

#[   if blue.int == red.int:
    result &= "1"
  elif blue.int < red.int:
    result &= "2"
  else: result &= "3"   ]#



var
  incr = 26#17 #51
  #r,g,b:int
  #hslDist:float
  choice: int
  rgb,rgb2, dist: tuple[r,g,b:int]
  found:bool
  #hslDist256, 
  huec:int
  huedivider = 14
  #hueDistance:float
  sdist:int
  r,g,b:int
  normalizer = 4
  h1:float
  hsl:tuple[h,s,l:float]


for rc in countup(0,255,incr):
  for gc in countup(0,255,incr):
    for bc in countup(0,255,incr):

      #[ r = rc#(rc div normalizer) * normalizer
      g = gc#(gc div normalizer) * normalizer
      b = bc#(bc div normalizer) * normalizer

      #huec = getCluster(RGBtoHSL(r.float,g.float,b.float).h, huedivider)
      hsl = RGBtoHSL(r.float,g.float,b.float) ]#

      found = false

      rgb = (rc,gc,bc)
      choice = 0

      dist.r = 9999
      dist.g = 9999
      dist.b = 9999
      
      #block SEARCH:
      #for d in countdown(255,0,1): # 256 colors
      for d in countdown(15,0,1):
        #rgb2 = extractRGB(Color256RGB[d])
        #if getForm(rc,gc,bc) == getForm(rgb2.r, rgb2.g, rgb2.b):  
        if true: 

          rgb2 = extractRGB(Color256RGB[d])

          if ( abs(rgb.r - rgb2.r) <= dist.r + 21 and # 11
              abs(rgb.g - rgb2.g) <= dist.g + 21 and
              abs(rgb.b - rgb2.b) <= dist.b + 21
            )
            :  
              choice = d
              found = true
              dist.r = abs(rgb.r - rgb2.r)
              dist.g = abs(rgb.g - rgb2.g)
              dist.b = abs(rgb.b - rgb2.b)




      echo found, ", R:", rc,
        ", G:", gc,
        ", B:", bc,
        " \x1b[38;2;" & $rc & ";" & $gc & ";" & $bc & "m ███\x1b[0m",
        " choice: \e[38;5;" & $int(choice) & "m " & "███ " & $choice & "\e[0m"