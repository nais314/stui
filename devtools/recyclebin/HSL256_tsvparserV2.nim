import parsecsv, parseutils, stui/colors_extra, stui/colors256, math

var 
  ofile, o2file: File

ofile = open("devtools/HSLx256_v2.nim",fmWrite)
ofile.write("const\n")

o2file = open("devtools/HSLDist256_v2.nim",fmWrite)
o2file.write("const\n")

proc getMin*[T](args: varargs[T]):T=
  result = T.high
  for arg in args:
    if arg < result:
      result = arg

proc getMax*[T](args: varargs[T]):T=
  for arg in args:
    if arg > result:
      result = arg

proc getDistance*(red,green,blue:float):float=
  result = sqrt(red * red + green * green + blue * blue  )

proc getDistance*(v:tuple[h,s,l:float]):float=
  result = sqrt(v.h * v.h + v.s * v.s + v.l * v.l  )

iterator countUp*(x,y,step:float):float=
  var r = x
  while r + step <= y:
    yield r
    r += step

proc getCluster*(x:float, divider:int=10, max:float=1.0):int=
  var counter: int = 1
  for c in countUp(max / divider.float, max, max / divider.float):
    if x <= c: 
      return counter
    counter += 1
  return counter


#[ proc getHUECluster*(h:float):char=
  if h < 0.1:
    return 'a'
  if h < 0.2:
    return 'b'
  if h < 0.3:
    return 'c'        
  if h < 0.4:
    return 'd'
  if h < 0.5:
    return 'e'
  if h < 0.6:
    return 'f'
  if h < 0.7:
    return 'g'
  if h < 0.8:
    return 'h'
  if h < 0.9:
    return 'i'

  return 'j'  ]#                               

proc RGBtoHSL*(red,green,blue:float): tuple[h,s,l:float]=
  var 
    r = red
    b = blue
    g = green
    h,l,s:float
    mi, ma:float

  r /= 255
  g /= 255
  b /= 255
  mi = getMin( r,g,b )
  ma = getMax( r,g,b )
  #h = (ma + mi) / 2
  l = (ma + mi) / 2
  #s = (ma + mi) / 2

  if ma == mi:
    h = 0
    s = 0
  else:
    h = l
    s = l

    var d = ma - mi

    s = if l > 0.5 : d / (2 - ma - mi) else: d / (ma + mi)

    if ma == r: h = (g - b) / d + (if g < b : 6 else: 0)
    if ma == g: h = (b - r) / d + 2
    if ma == b: h = (r - g) / d + 4

    h /= 6

  result = (h,s,l)

var 
  r,g,b:float
  h,l,s:float
  mi, ma:float
  str1:string
  tok1:int
  counter:int
  #c1,c2:char
  c1,c2:int
  c1h,c2h,c1s,c2s,c1l,c2l:int
  d1,d2:float
  choice: tuple[s,l:float, c,h,r,g,b:int]
  needle: tuple[name:string, r,g,b:int]

#c1 = getHUECluster(RGBtoHSL(0.0, 127.0, 255.0).h)
#c1 = getCluster(RGBtoHSL(0.0, 127.0, 255.0).h)
d1 = getDistance(RGBtoHSL(0.0, 127.0, 255.0))

needle = (name: "Azure", r:0, g:127, b:255)

var hsl1 = RGBtoHSL(0.0, 127.0, 255.0)
c1h = getCluster(hsl1.h, 200)
c1s = getCluster(hsl1.s, 100)
c1l = getCluster(hsl1.l, 100)

choice.h = 9999

var p: CsvParser
p.open("devtools/256colornames.tsv",'\t')
while p.readRow():
  #echo p.row[3]
  tok1 = p.row[3].parseUntil(str1, '(') + 1
  
  tok1 += parseFloat(p.row[3],r,tok1) + 1
  tok1 += parseFloat(p.row[3],g,tok1) + 1
  tok1 += parseFloat(p.row[3],b,tok1)
  #echo r, " ", g, " ", b

  (h,s,l) = RGBtoHSL(r,g,b)

  c2h = getCluster(h, 200)
  c2s = getCluster(s, 100)
  c2l = getCluster(l, 100)

  if c2h == c1h :
    #if choice.h != c2h: choice.h = c2h #TODO

    if abs(sqrt(
        (hsl1.s * hsl1.s + hsl1.l * hsl1.l).float -
        (s * s + l * l).float) ) <
        abs(sqrt(
        (hsl1.s * hsl1.s + hsl1.l * hsl1.l).float -
        (choice.s * choice.s + choice.l * choice.l).float )):
            choice.c = counter
            choice.h = c2h
            choice.l = l
            choice.s = s
            choice.r = r.int
            choice.g = g.int
            choice.b = b.int

    #[ if abs(c1s - c2s) == abs(c2s - choice.s):
      if abs(c1l - c2l) < abs(c2l - choice.l):
        choice.c = counter
        choice.h = c2h
        choice.l = c2s
        choice.s = c2l
        choice.r = r.int
        choice.g = g.int
        choice.b = b.int
    elif abs(c1s - c2s) < abs(c2s - choice.s):
      choice.c = counter
      choice.h = c2h
      choice.l = c2s
      choice.s = c2l
      choice.r = r.int
      choice.g = g.int
      choice.b = b.int ]#




  ofile.write("  " & $Color256(counter) & " = ( " & $h & ", " & $s & ", " & $l & " ),\n")

  o2file.write("  " & $Color256(counter) & " = " & $getDistance((h,s,l)) & ",\n")

  counter += 1

p.close()

ofile.close()
o2file.close()


echo "\n Choice: ", $Color256(choice.c),
  ", R", choice.r,
  ", G", choice.g,
  ", B", choice.b,
  ", R", needle.r,
  ", G", needle.g,
  ", B", needle.b,
  "\e[38;5;" & $int(choice.c) & "m " & "███ " & $choice.c & "\e[0m",
  "\x1b[38;2;" & $needle.r & ";" & $needle.g & ";" & $needle.b & "m ███\x1b[0m\n"