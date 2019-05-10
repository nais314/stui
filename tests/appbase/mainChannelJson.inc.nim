var interCom = getIntercom()
let myThId = 0 #getThreadId()
interCom.addFeed(0)
interCom[0][myThId] = getMcjChannel()
open interCom[0][myThId][]

proc handleMainChannelJsonChecked()= #! OVERWRITE THIS
  when defined debugTrace_enabled: debugEcho  ">>>>>>  handleMainChannelJsonChecked"
  open interCom[0][myThId][]
  block: #for iMsg in 0..1: #? anti flood
    var inbox = tryRecv( interCom[0][myThId][] ) #tuple[dataAvailable: bool, msg: TMsg]
    if inbox.dataAvailable:
      
      var jsonNode = parseJson(inbox.msg)
      let msgtyp = jsonNode["typ"].getInt()
      let msgfrom = jsonNode["from"].getInt()

      ## case msgtyp:
      ## recommendation: 0: test, 1-999 system preserved, 1000- applications fun
      case msgtyp: #! OVERWRITE WITH YOUR OWN FUN
      of 0:
        when defined debugInfo_enabled: debugEcho  ">>>>>> hello from json channel"
        if msgfrom != 0 and msgfrom != myThId:
            interCom[0].sendTo(msgfrom, """{ "r": 42 }""") # result=42
            when defined debugInfo_enabled: debugEcho ">>>>>> reply sent...", msgfrom
      of 101:
        when defined debugTrace_enabled: debugEcho ">>>>>>  adding new thread comm channel \n", inbox.msg
        #when defined debugInfo_enabled: debugEcho inbox.msg
        if msgfrom != 0 and msgfrom != myThId:
          var feedname = jsonNode["feed"].getInt()

          if not interCom.hasKey(feedname):
            interCom.addFeed(feedname)

          var chan = jsonNode["chanPtr"].getChannelJson() #cast[ptr ChannelJson](cast[uint](jsonNode["chanPtr"].getInt()))[]

          open chan[] # [] -> chan is ptr or ref, needs []
          interCom[feedname].subscribe( msgfrom, chan )
          when defined debugInfo_enabled: debugEcho ">>>>>>  ", interCom.hasKey(0)
          #when defined debugInfo_enabled: debugEcho interCom[feedname].hasKey(msgfrom)
          interCom[feedname].sendTo(msgfrom, """{ "r": 0 }""")

      else: discard

    else: break #inbox.dataAvailable
    sleep(0)