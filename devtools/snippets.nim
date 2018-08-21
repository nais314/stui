import stui, terminal, colors, colors_extra, colors256 unicode, tables



proc drawit(this: Controll) =
    draw(Button(this))

proc focus(this: Controll)=
    this.activeStyle = this.styles["input:focus"]

proc blur(this: Controll)=
    this.activeStyle = this.styles["input"]

proc cancel(this: Controll)=discard


proc onClick(this: Controll, event:KMEvent)=discard

proc onDrag(this: Controll, event:KMEvent)=discard

proc onDrop(this: Controll, event:KMEvent)=discard

proc onKeyPress(this: Controll, event:KMEvent)=discard