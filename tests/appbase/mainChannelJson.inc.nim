# the beginning is might verbose a bit, but its now reusable in submodules
# with adjusting the thread id and channel
var interCom = getIntercom()
let myThId = 0 #getThreadId() # main thread is thread 0
interCom.addFeed(0) # init main thread - 0 - channels
interCom[0][myThId] = getMcjChannel() # main thread uses the pre declared json channel
open interCom[0][myThId][]

proc handleMainChannelJsonChecked()= #! OVERWRITE THIS
  when defined(logger_enabled): debug  ">>>>>>  handleMainChannelJsonChecked"
  open interCom[0][myThId][]

  var inbox = tryRecv( interCom[0][myThId][] ) #tuple[dataAvailable: bool, msg: TMsg]
  if inbox.dataAvailable:
    notice inbox.msg
    
    var jsonNode = parseJson(inbox.msg)
    let msgtyp = jsonNode["typ"].getInt() # [] returns exception if not set!
    let msgfrom = jsonNode{"from"}.getInt() # {} returns default if not set.

    ## case msgtyp:
    ## recommendation: 0: test, 1-999 system preserved, 1000- applications fun

    case msgtyp: #! OVERWRITE WITH YOUR OWN FUN
    of 0:
      when defined(logger_enabled): notice ">>>>>> hello from json channel"
      if msgfrom != myThId: # do not send to yourself - deadlock
          interCom[0].sendTo(msgfrom, """{ "r": 42 }""") # result=42
          when defined(logger_enabled): notice ">>>>>> reply sent...", msgfrom

    of 101: # add a channel to intercom - a thread registers in intercom
      when defined(logger_enabled): notice ">>>>>>  adding new thread comm channel \n", inbox.msg
      if msgfrom != myThId: # main channel is pre registered
        var feedname = jsonNode["feed"].getInt()

        if not interCom.hasKey(feedname):
          interCom.addFeed(feedname)

        var chan = jsonNode["chanPtr"].getChannelJson() #cast[ptr ChannelJson](cast[uint](jsonNode["chanPtr"].getInt()))[]

        open chan[] # [] -> chan is ref, needs [] to get the Channel
        interCom[feedname].subscribe( msgfrom, chan )
        when defined(logger_enabled): notice ">>>>>>  ", interCom.hasKey(0)
        interCom[feedname].sendTo(msgfrom, """{ "r": 0 }""")

    of 1:
      notice "THE END"
      withLock app.termlock: quit()

    else: discard

    sleep(0) # cpuRelax