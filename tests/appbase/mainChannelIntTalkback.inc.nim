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
  when defined(logger_enabled): debug "---=== mainChannelIntTalkback[].peek()> ", mainChannelIntTalkback[].peek()
  block: #for iMsg in 0..1: #? anti flood
    var inbox = tryRecv( (mainChannelIntTalkback[]) ) #tuple[dataAvailable: bool, msg: TMsg]
    if inbox.dataAvailable:
        when defined(logger_enabled): debug "---=== handleMainChannelIntTalkback recv> ", inbox.msg[]
        case inbox.msg[]:
            of 1:
                when defined(logger_enabled): notice  "---=== Hello handleMainChannelIntTalkback!"
                atomicInc(inbox.msg[])

            of 256..int.high:
                #when defined(logger_enabled): notice  "---=== Hello handleMainChannelIntTalkback! unpackIntMsg"
                var msg = unpackIntMsg(inbox.msg[].uint)
                when defined(logger_enabled): 
                    notice "---=== handleMainChannelIntTalkback unpackIntMsg msg> ", msg
                atomicInc(inbox.msg[])

            else:
                when defined(logger_enabled): notice "---=== handleMainChannelIntTalkback> else"
                app.trigger($ inbox.msg[])
                atomicInc(inbox.msg[])
    else: break
    sleep(0)