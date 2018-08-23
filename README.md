# stui
Simplified Terminal UI (Nim lang, ANSI)

This is my first app in Nim.

STUI is a drag&drop aware ANSI terminal UI.

It can Tile the screen vertically, Tiles can have relative "50%" or exact "100ch" width.

Controlls layout is automatically computed - from top to bottom, left to right.
Controlls can have relative or exact width / heigth.

STUI can handle more screens - WorkSpaces

It can be themed with parseCfg compatible files (.TSS)

Demo / test file is stui_test1.nim

TODO:
# todo: ColumnBreak test
# todo: app addeventlistener fnkey action trigger test
# todo: widgets: class, activearea
# todo: window menu, buttons
# todo: window onclick, rightclick
# todo: tss.nim
# todo: intro, doc
# todo: splash
# todo: filechooser (dir, fname, exists)
# todo: ListItem, ListBox - header, table columns, ???
# todo: setEnabled(this:Controll) ?: set style to what?
# todo: banner?
