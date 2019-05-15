when isMainModule: import strutils # debug echo string format

when sizeof(int) >= 8:
  const PackedIntMsgBits* = [16,16,16,16]

when sizeof(int) == 4:
  const PackedIntMsgBits* = [8,8,16,0] #256, 256, 65536, 0

type
  PackedIntMsg* = array[0..3, uint]


proc packIntMsg*(pc: PackedIntMsg):uint=
  result = 0
  for i in 0..3:
    result = result or pc[i]
    when isMainModule: echo toBin(result.int,sizeof(uint)*8), " - ", toBin(pc[i].int, sizeof(uint)*8)
    if i < 3 : result = result shl PackedIntMsgBits[i]
    

proc unpackIntMsg*(pc: uint):PackedIntMsg=
  var bitshift:int
  var c = 3 # reverse array
  for i in 0..3: #countdown(3,0):
    bitshift = 0
    for c in 0..<i: # calculate bit shift
      bitshift += PackedIntMsgBits[c]
    result[c] = pc shr bitshift and 0xff #mask non needed bits
    when isMainModule: echo toBin(result[c].int, sizeof(uint)*8)
    c -= 1 # reverse array
    

when isMainModule:
  var ta: PackedIntMsg
  ta = [5.uint,7.uint,4.uint,8.uint]
  echo ta
  var pc = packIntMsg(ta)
  echo pc
  echo unpackIntMsg(pc)
