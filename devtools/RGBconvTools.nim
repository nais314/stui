import HSLtools

proc achromatic*(r,g,b:int):bool=
  let norm = 20
  var 
    r = r
    g = g
    b = b
  if r > 0 and g > 0 and b > 0:
    r = r div norm * norm
    g = g div norm * norm
    b = b div norm * norm
  result = r == g and g == b

type HUEnum* = enum
  Red,
  Orange,
  Yellow,
  Lime,

  Green,
  Turquise,
  Blue,

  Navy,
  Purple,
  Magenta,
  Pink,

  Red2,
  Gray


proc hueClass16*(r,g,b:int): HUEnum =
  if achromatic(r,g,b): return HUEnum.Gray

  var hue = RGBtoHSL(r.float,g.float,b.float)
  let secLen = 1.0 / 12.0#12.0
  let halfSec = 1.0 / 24.0

  var sec1 = hue.h #/ secLen

  if sec1 < halfSec :
    result = HUEnum.Red
  elif sec1 > 1.0 - halfSec:
    result = HUEnum.Red

  elif sec1 < halfSec + secLen:
    result = HUEnum.Red #HUEnum.Orange
  elif sec1 < halfSec + secLen * 2:
    result = HUEnum.Yellow    
  elif sec1 < halfSec + secLen * 3:
    result = HUEnum.Yellow #HUEnum.Lime
  elif sec1 < halfSec + secLen * 4:
    result = HUEnum.Green

  elif sec1 < halfSec + secLen * 5:
    result = HUEnum.Green #HUEnum.Turquise    
  elif sec1 < halfSec + secLen * 6:
    result = HUEnum.Blue
  elif sec1 < halfSec + secLen * 7:
    result = HUEnum.Blue #HUEnum.Blue

  elif sec1 < halfSec + secLen * 8:
    result = HUEnum.Navy    
  elif sec1 < halfSec + secLen * 9:
    result = HUEnum.Navy #HUEnum.Purple
  elif sec1 < halfSec + secLen * 10:
    result = HUEnum.Magenta

  #[ elif sec1 < halfSec + secLen * 11:
    result = HUEnum.Pink  ]#
  elif sec1 < halfSec + secLen * 11:
      result = HUEnum.Magenta    



proc hueClass256*(r,g,b:int): HUEnum =
  if achromatic(r,g,b): return HUEnum.Gray

  var hue = RGBtoHSL(r.float,g.float,b.float)
  let secLen = 1.0 / 12.0#12.0
  let halfSec = 1.0 / 24.0

  var sec1 = hue.h #/ secLen

  if sec1 < halfSec :
    result = HUEnum.Red
  elif sec1 > 1.0 - halfSec:
    result = HUEnum.Red

  elif sec1 < halfSec + secLen:
    result = HUEnum.Orange
  elif sec1 < halfSec + secLen * 2:
    result = HUEnum.Yellow    
  elif sec1 < halfSec + secLen * 3:
    result = HUEnum.Lime
  elif sec1 < halfSec + secLen * 4:
    result = HUEnum.Green

  elif sec1 < halfSec + secLen * 5:
    result = HUEnum.Turquise    
  elif sec1 < halfSec + secLen * 6:
    result = HUEnum.Blue
  elif sec1 < halfSec + secLen * 7:
    result = HUEnum.Blue

  elif sec1 < halfSec + secLen * 8:
    result = HUEnum.Navy    
  elif sec1 < halfSec + secLen * 9:
    result = HUEnum.Purple
  elif sec1 < halfSec + secLen * 10:
    result = HUEnum.Magenta

  elif sec1 < halfSec + secLen * 11:
    result = HUEnum.Pink 
  #[ elif sec1 < halfSec + secLen * 11:
      result = HUEnum.Magenta ]#   