# stui
### Simplified Terminal UI (Nim lang, ANSI) 

This is my first app in Nim.

** STUI is a drag&drop aware, responsive layout ANSI terminal UI.**

branches:
* master: stable, but main loop is sequential
* ptr: trying to solve things with "app: ptr App" but crashes
* channels: add a Channel loop to master -> threads may launch main-threds procs etc


It can Tile the screen vertically, Tiles can have relative "50%" or exact "100ch" width.

Controlls layout is automatically computed - from top to bottom, left to right.
Controlls can have relative or exact width / heigth.

STUI can handle more screens - WorkSpaces

  App->WorkSpaces->Tiles->Windows->Pages->Controlls


It can be themed with parseCfg compatible files (.TSS)

**Demo / test file is stui_test1.nim**

**Dependency: like Deja-Vu TTF - a font with large unicode character set**

###TODO:

(branch channels) main program skeleton / design pattern for better multithreading

- ColumnBreak test
- app addeventlistener fnkey action trigger test
- WS: switch ok, recalc ok
- widgets: class, activearea
- window menu, buttons
- window onclick, rightclick
- tss.nim
- intro, doc
- splash
- filechooser (dir, fname, exists)
- ListItem, ListBox - header, table columns, ???
- setEnabled(this:Controll) ?: set style to what?
- banner? parse ASCII font
