import math, strutils, RGBx256table, stui/colors_extra, HSLtools, HSL256table

import RGBconvTools



var
  incr = 51#17 #51

  choice: int
  rgb,rgb2, dist: tuple[r,g,b:int]
  found:bool
  disterror: int


for rc in countup(0,255,incr):
  for gc in countup(0,255,incr):
    for bc in countup(0,255,incr):

      #[ r = (rc div normalizer) * normalizer
      g = (gc div normalizer) * normalizer
      b = (bc div normalizer) * normalizer ]#

      #[ #huec = getCluster(RGBtoHSL(r.float,g.float,b.float).h, huedivider)
      hsl = RGBtoHSL(r.float,g.float,b.float) ]#

      found = false

      disterror = 11

      while not found and disterror < 100:

        rgb = (rc,gc,bc)
        #rgb = (r,g,b)
        choice = 0
        

        dist.r = 999
        dist.g = 999
        dist.b = 999

        for d in countdown(255,0,1):
 
          if true: 

            rgb2 = extractRGB(Color256RGB[d])

            if ( abs(rgb.r - rgb2.r) <= dist.r + disterror and # 11
                abs(rgb.g - rgb2.g) <= dist.g + disterror and
                abs(rgb.b - rgb2.b) <= dist.b + disterror
              ) and 
              (hueClass256(rgb.r,rgb.g,rgb.b) == hueClass256(rgb2.r,rgb2.g,rgb2.b) ) and
              (achromatic(rgb.r,rgb.g,rgb.b) == achromatic(rgb2.r,rgb2.g,rgb2.b))
              :  
                choice = d
                found = true
                dist.r = abs(rgb.r - rgb2.r)
                dist.g = abs(rgb.g - rgb2.g)
                dist.b = abs(rgb.b - rgb2.b)


        if not found and disterror < 100:
          disterror += 3



      echo found, ", R:", rc,
        ", G:", gc,
        ", B:", bc,
        " \x1b[38;2;" & $rc & ";" & $gc & ";" & $bc & "m \t███\x1b[0m ",
        " \e[38;5;" & $int(choice) & "m " & "\t███ " & $choice & "\e[0m ",
        hueClass256(rc,gc,bc)