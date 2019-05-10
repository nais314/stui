## mainChannelIntTalkback retrives a `ptr int` - so [] needed to get value -
## then, it `atomicInc(inbox.msg[])` increases its value, so, the
## sender thread knows, its been handled.
## the thread can wait for the result - so SEGFAULT etc not occurs
## simple and fast result/release...
##
## mainChannelIntTalkback is a ref Channel[ptr int],
## so to use it `[]` is needed.
## ref Channel can be passed to submodules => getMcitChannel()
##
## import appbase/intchannelutils
## var msg = unpackIntMsg(inbox.msg[].uint) returns an array[0..3, uint]
## so, you have a 4 level message tree if you like/see so
## like app functions (1), shop functions (11), shop fun category (x), shop fun (243)
## levels based on int size, see src


var mainChannelIntTalkback = getMcitChannel()
mainChannelIntTalkback[].open()

import appbase/intchannelutils

proc handleMainChannelIntTalkback()= #! OVERWRITE THIS
  when defined(debugTrace_enabled): debugEcho "---=== mainChannelIntTalkback[].peek()> ", mainChannelIntTalkback[].peek()
  block: #for iMsg in 0..1: #? anti flood
    var inbox = tryRecv( (mainChannelIntTalkback[]) ) #tuple[dataAvailable: bool, msg: TMsg]
    if inbox.dataAvailable:
        when defined(debugInfo_enabled): debugEcho "---=== handleMainChannelIntTalkback recv> ", inbox.msg[]
        case inbox.msg[]:
            of 1:
                echo "---=== Hello handleMainChannelIntTalkback!"
                atomicInc(inbox.msg[])

            of 256..int.high:
                echo "---=== Hello handleMainChannelIntTalkback!"
                var msg = unpackIntMsg(inbox.msg[].uint)
                debugEcho "---=== handleMainChannelIntTalkback msg> ", msg
                atomicInc(inbox.msg[])

            else:
                when defined(debugInfo_enabled): debugEcho "---=== handleMainChannelIntTalkback> else"
                app.trigger($ inbox.msg[])
                atomicInc(inbox.msg[])
    else: break
    sleep(0)