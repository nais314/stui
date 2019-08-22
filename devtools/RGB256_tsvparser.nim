import parsecsv, parseutils, stui/colors_extra

var ofile: File

ofile = open("devtools/RGBx256table.nim",fmWrite)

ofile.write("const Color256RGB* = [ \n")



var 
  r,g,b:int
  rgb: PackedRGB
  str1:string
  tok1:int

var p: CsvParser
p.open("devtools/256colornames.tsv",'\t')
while p.readRow():
  echo p.row[3]
  tok1 = p.row[3].parseUntil(str1, '(') + 1
  
  tok1 += parseInt(p.row[3],r,tok1) + 1
  tok1 += parseInt(p.row[3],g,tok1) + 1
  tok1 += parseInt(p.row[3],b,tok1)
  echo str1, r,g,b

  rgb = packRGB(r,g,b)

  ofile.write("    " & $rgb & ",\n")

p.close()

ofile.write("]")
ofile.close()