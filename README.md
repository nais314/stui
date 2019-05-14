# stui
### Simplified Terminal UI (Nim lang, ANSI terminal) 

This is my first big app in Nim - it covers pretty much anything i need (to learn) >:)

**STUI is a drag&drop aware, responsive layout, themeable, ANSI terminal UI. (currently for linux terminals...)**  
  
**News: APPBASE is now built into STUI - or STUI is build on top of APPBASE wich brings InterCom - inter thread communications - to the table**  
  
branches:
* master: usable alpha, revised for **nim v0.19.6** stable and **nim v0.19.9**, devel - *stable has no unicode.align == compile error; delete unicode. for nim 0.19.0 stable*  
  
releases:
* nim 0.18 version archived as release

(manjaro linux, visual studio code [better comments])  
  

Status: usable alpha. missing: widgets, banners, splash; docs, cleanup  
  see: stui_test1.nim  
  copy&use: template_simpleapp.nim  
  tested on xfce4terminal, gnome-terminal  

![Screenshot_stui_test1.nim](doc/Screenshot_2018-10-03_15-23-40.png)

Please help the development with your feedback. :)  



**News: DoubleClick enabled, LineGraph controll first alpha release =)**

**Future changes: enable Style inheritance; testing for isNil may replaced with dummy procs for GC safety; MaximizableControlls (doing); .nimble fixxes**


It can Tile the screen vertically, 
Tiles can have relative "50%" or exact "100ch" width.

Windows are filling the Tile, and cascade over each other, 
covering each other fully - only titlebar visible ("breadcrumbs like")
Windows cannot be moved, etc.

Controlls layout is automatically computed - from top to bottom, left to right.
Controlls can have relative or exact width / heigth
or manually if Controll.recalc() is added then it sets x1,x2,y1,y2,width,heigth.

Terminal resize is watched in every 2 secs - on resize layout recalculated.

STUI can handle more screens - **WorkSpaces**  

  **tree: App->WorkSpaces->Tiles->Windows->(Pages->)Controlls**  

  PageBreak is not inserted into pages.controlls[]  


It can be **themed** with parseCfg compatible files *(.TSS)* style sheets


**Event listeners: Observer style:**  

    Listener = tuple[name:string, actions: seq[proc(source:Controll):void]]

    ListenerList = seq[Listener]

    proc addEventListener*(controll:Controll, evtname:string, fun:proc(source:Controll):void)

    proc removeEventListener*(controll:Controll, evtname:string, fun:proc(source:Controll):void)

    proc trigger*(controll:Controll, evtname:string )

    e.g.:
        selectbox2.addEventListener("change", changeColorMode)

        proc changeColorMode(source:Controll)=
        discard parseInt(sb2.value, source.app.colorMode)
        source.app.draw()



**Demo / test file is stui_test1.nim** - use F10 or 2x ESC to Quit

**App template: template_simpleapp.nim**

**Dependency: like Deja-Vu TTF - a font with large unicode character set & terminal, like xfce4 terminal**  
![nerd fonts](https://github.com/ryanoasis/nerd-fonts/wiki)  


* ui_textbox: text input, 1 line 
* ui_button  
* ui_textarea: multi line textbox, editable, scrollable
* ui_menu: full screen hierarchial menu - breadcrumbs in window
* ui_stringlistbox: like a listbox, items having actions, not for (multi)selection (will continue)
* ui_progressbar
* ui_fineprogressbar: uses unicode block characters; can be colored by level (normal, warn, err)
* ui_selectbox: (multi) selectbox - it is a combined controll
* ui_togglebutton: on or off :)
* ui_shdbutton: button with drop shadow - just like in the good old times...
* _ui_fileselect (beta): <NEW><DEVEL>_ well it is also a sandbox for testing Controll reusability and combined controlls
* _ui_linegraph (beta):_ a "bargraph", paging, scrolling works, RIGHT-CLICK TO MAXIMIZE! =) 
*ok...maybe ui_linegraph is a little bit complicated, maybe some day, on demand i will fork a quick&dirty version from it*

**Demo / test file is stui_test1.nim**

    Default Keyboard Shortcuts:
        F2: menu TODO
        F5: refresh screen
        F9: menu TODO
        F10: quit app

        TAB: - add focus to next gui Controll; 
             - commit changes to Controll (e.g.:TextArea)

        ESC and ESC again: cancel editing, quit app

        PgUP/PgDown: on Window -> change Page; on TextArea: "scroll"

    Mouse:
        Wheel "Scrolls": Window->Page; TextArea, LineGraph

![Screenshot_2018-09-14_14-07-41](doc/Screenshot_2018-09-14_14-07-41.png)  
![FileSelect](doc/FileSelect_Screenshot_2018-10-20_13-35-40.png)  
![LineGraph1](doc/LineGraph1.png)  
![LineGraph2](doc/LineGraph2.png)
![Screenshot_2018-09-14_14-07-18](doc/Screenshot_2018-09-14_14-07-18.png)  


  [on colors ...](doc/Colors.md)  
  [on Controll ...](doc/Controlls.md)  


**APPBASE functions**

    the builded applications nim.cfg controlls wich components are enabled:

        --define:inputEventLoop_enabled # main HID event loop
        --define:mainChannelInt_enabled 
        --define:mainChannelString_enabled
        --define:mainChannelIntTalkback_enabled # sends ptr int, change int value to talk back
        --define:mainChannelIntChecked_enabled # sends int and ptr Channel[int] to talk back
        --define:mainChannelJsonChecked_enabled # aka InterCom
        --define:timedActions_enabled

    appbase/mainChannel... .inc.nim files are boilerplates for Channel handling
    appbase/myappbasetypes is the glue, where stui connected to appbase
    appbase.mainloop template runs timers, channelhandlers and eventloop
    
    stui_template.nim is derived from appbase template for stui
    main.inc.nim is your programs main file, wich will be included in the boilerplate

[more on appbase ...](doc/appbase.md)



I think, that even if i go back to my IOT projects, 
it is an easy to maintain, extend, dependency free project.




