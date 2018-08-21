import parsecsv

var ofile: File

ofile = open("ColorsX256",fmWrite)

ofile.write("type Color256 = enum\n")

type
    color256 = tuple[name: string, num: string]
var
    c256: color256



var p: CsvParser
p.open("256colornames.tsv",'\t')
while p.readRow():
    var c:int = 0
    for val in items(p.row):
        if c <= 1:
            #echo "##", val, "##"
            if c == 0:
                c256.num = val
            else:
                c256.name = val
        c += 1
    echo c256
    ofile.write("    " & c256.name & " = " & c256.num & ",\n")

p.close()

ofile.close()