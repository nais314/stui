#import io

var file = open("256to16.list", fmWrite)

for i in 0 .. 255:
  ## Erases the screen with the background colour and moves the cursor to home.
  stdout.write "\e[2J\e[H"

  echo("\e[38;5;" & $i & "m " & "███ " & $i & "\e[0m" & " " & $i) 
  #echo("\e[38;5;" & $i & "m " & "███ " & $i & "\e[0m" & " " & $i) 
  #echo("\e[38;5;" & $i & "m " & "███ " & $i & "\e[0m" & " " & $i) 

  #echo "\n\n"

  var  ii = 30
  while ii < 38:
    stdout.write("\e[0m" & " " & $ii & "\e[" & $ii & "m " & "███   ")
    ii.inc
  stdout.write("\n")
  ii = 30
  while ii < 38:
    stdout.write("\e[0m" & " " & $ (ii + 60) & "\e[" & $ (ii + 60) & "m " & "███   " )
    ii.inc

  stdout.write("\n>")
  var c = stdin.readLine()

  file.write(c & ",\n")

file.close()