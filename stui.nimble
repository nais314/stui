# Package

version       = "0.1.201812"
author        = "Istvan Nagy"
description   = "Simplified Terminal UI for ANSI terminals"
license       = "GPLv3"
srcDir        = "src"

# Dependencies

requires "nim >= 0.19.0"

task test, "Runs the test suite":
  exec "nim c -r tests/stui_test1.nim"