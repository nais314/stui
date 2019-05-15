# Package

version       = "0.1.20190515"
author        = "Istvan Nagy"
description   = "Simplified Terminal UI for ANSI terminals"
license       = "GPLv3"
srcDir        = "src"

# Dependencies

requires "nim >= 0.19.6"

task test, "Runs the test suite":
  exec "nim c -r tests/stui_test1.nim"

task testold, "Runs the test suite":
  exec "nim c -r tests/stui_template.nim"