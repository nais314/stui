see stui.nim, textbox.nim

Controll is a ui element.

app.activeControll: set this if focus changes  

`value`: is a string representation of the ..., for using in SQL etc...  
`value2`: is [T] representation of the value - if applicable  

other value/name functions as needed - see selectbox


disabled: used in mouse/key handlers

visible: used in draw()

drawit(): maybe methods would be better, but methods cannot be FWD declared (? nim 0.18)

activeStyle: from the controlls styles the currently active one - for draw


Event flow, automatic KM events: (Keyboard & Mouse)  

    see mainloop.inc.nim  
  
    than stui.nim mouseEventHandler:
        eventTarget.onClick(eventTarget, event)
        eventTarget.onScroll(eventTarget, event)
        app.dragSource.onDrag(eventTarget, event)
        eventTarget.onDrop(eventTarget, event)

    key events:
        if KeyPgUp, KeyPgDown trigger controlls proc first then apps
        else: trigger apps cb first, then controlls


**Window**

"menu" event fired when clicked on titlebar menu button
