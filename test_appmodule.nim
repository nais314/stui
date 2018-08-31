import stui, os, threadpool



proc channeltest(miso:ptr Channel[string]){.thread.}=
    for i in 0..4:
        discard trySend(miso[], "test1")
        #sleep(500)
    discard trySend(miso[], "test2")

proc main*(app:App)=
    let win = app.activeWorkSpace.tiles[0].newWindow("appmodule test")
    app.redraw()

    
    discard trySend(app.itc[], "test1")

    app.activeWindow.setTitle("set title")

    #[ for i in 0..15:
        discard trySend(app.itc[], "test1")
        sleep(500) ]#

    var th : Thread[ptr Channel[string]]
    createThread[ptr Channel[string]](th, channeltest, app.itc)
    joinThread(th)
    