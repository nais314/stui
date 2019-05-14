import os, locks, times, tables, json


#-------------------------------------------------------------------------------
# Base Types - to extend
type
  EventRoot* = object of RootObj#dummy base

  TimedAction* = tuple[name:string,interval:float,action:proc():void,lastrun:float] # epochTime:float
  
  AppBase* = ref object of RootObj
    ## AppBase:------------------------------
    ##   extend with your needed fields: MyApp* = ref object of AppBase
    threadId*:int
    listeners*: seq[tuple[name:string, actions: seq[proc():void]]]
    timers*: seq[TimedAction] #seq[tuple[name:string,interval:float,action:proc()]]


#-------------------------------------------------------------------------------
#TODO channel types on 32/64 bits: two or multi level int channels, like ipv4
#TODO ptr passing channel with "lock&release" 
#TODO   i2 = cast[ptr uint](addr(pi))[]
#TODO  pi2 = cast[ptr int](i2)

#! Base Channels
when defined mainChannelLog_enabled:
  type LogChannel* = ref Channel[string]
  var mainChannelLog = new LogChannel 
  proc getLogChannel*(): LogChannel = mainChannelLog #! <-- getter ----

when defined mainChannelString_enabled:
  type McsChannel* = ref Channel[string]
  var mainChannelString = new McsChannel 
  proc getMcsChannel*(): McsChannel = mainChannelString #! <-- getter ----


when defined mainChannelInt_enabled:
  type MciChannel = ref Channel[int]
  var mainChannelInt = new MciChannel
  proc getMciChannel*(): MciChannel = mainChannelInt #! <-- getter ------------


when defined mainChannelIntChecked_enabled:
  type 
    McicChannel* = ref Channel[tuple[val:int,chan:ptr Channel[int]]]
  var mainChannelIntChecked = new McicChannel #Channel[tuple[val:int,chan:ptr Channel[int]]]
  proc getMcicChannel*(): McicChannel = mainChannelIntChecked #! <-- getter -----

when defined mainChannelIntTalkback_enabled:
  ## a talkback channel sends a pointer to a mutable variable, eg int,
  ## and changes it after operation -> change can be checked, variable can be
  ## destroyed
  ## atomicInc(intPtr[])
  type McitChannel* = ref Channel[ptr int]
  var mainChannelIntTalkback = new McitChannel
  proc getMcitChannel*(): McitChannel = mainChannelIntTalkback #! <-- getter -----

  proc waitFor*(chan: var McitChannel, msg: var int)=
    ## support proc: in a thread, sends ptr int then waits for talkback
    var temp = msg
    chan[].send(addr msg)
    while temp == msg:
      sleep(1)



when defined mainChannelJsonChecked_enabled:
  ##!Thread InterComm, Json

  #! SUPPORT FUNCTIONS

  proc `%`*(p:pointer): JsonNode =
    ## store pointer as JsonNode, JInt
    when NimPatch < 9:  %(cast[int](p))
    else : %(cast[uint](p))

  
  proc `<--`*[T](i:var uint, p:var T) =
    ## box operator: convert pointer to uint
    ## just to hide that ugly cast ;)
    i = cast[uint](p)

  proc `<--`*[T](p: var T, i: var uint)=
    ## box operator: convert uint to pointer
    ## just to hide that ugly cast ;)
    p = cast[T](i)

  proc `-->`*[T](p: var T, i: var uint) =
    ## box operator: convert pointer to uint
    ## just to hide that ugly cast ;)
    i = cast[uint](p)

  proc `-->`*[T](i:var uint, p:var T)=
    ## box operator: convert uint to pointer
    ## just to hide that ugly cast ;)
    p = cast[T](i) 


  #!........................................
  type
    # Main Channel [ msgtyp: int, msg: json ]
    #TODO ErrorCodeChannel* = Channel[ptr int] #REM: atomicInc(rchi[])
    ChannelJson* = ref Channel[string]
    MainChannelJsonFeeds* = TableRef[int, ChannelJson] # TH id, Json
    InterCom* = TableRef[int, MainChannelJsonFeeds]

  var mainChannelJson = new ChannelJson
  proc getMcjChannel*():ChannelJson= mainChannelJson #! <-- getter -------------
  
  var interCom = newTable[int, MainChannelJsonFeeds]()
  proc getInterCom*():InterCom = 
    ## returns the intercom:
    ## a table of Json Channels tables
    ##  MainChannelJsonFeeds* = TableRef[int, ChannelJson] # Thread id, Json
    ##  InterCom* = TableRef[int, MainChannelJsonFeeds] # feedname, jsonfeeds
    interCom  #! <-- getter -----------------------





  proc broadcast*(feed: var MainChannelJsonFeeds, msg:string)=
    ## send msg to all feed subscribers
    for thId, listener in feed:
      open feed[thId][]
      feed[thId][].send(msg)

  proc sendTo*(feed: var MainChannelJsonFeeds, recip:int, msg:string)=
    ## send msg to recip, who is subscribed to feed 
    for thId, listener in feed:
      if thId == recip:
        open feed[thId][]
        when defined debugInfo_enabled: debugEcho getThreadId(), " sendTo > ", recip
        feed[thId][].send(msg)
        when defined debugInfo_enabled: debugEcho getThreadId(), " peek > ", feed[thId][].peek()
        sleep(1)

  proc sendTo*(icom: var InterCom, recip:int, msg:string)=
    ## send msg to recip, finds recip in intercom
    var chan:ChannelJson # feed is immutable
    for feedname, feed in icom:
      for thId, listener in feed:
        if thId == recip:
          chan = feed[thId] # feed is immutable, cannot send
          open chan[]
          chan[].send(msg)





  proc getChannelJsonPtr*(n: JsonNode): ptr ChannelJson =
    ## Retrieves the  int value as pointer  of a `JInt JsonNode`.
    ##
    ## Returns ``default`` if ``n`` is not a ``JInt``, or if ``n`` is nil.
    if n.isNil or n.kind != JInt: return nil
    else: return cast[ptr ChannelJson](cast[uint](n.num))

  proc getChannelJson*(n: JsonNode): ChannelJson =
    ## Retrieves the  int value as pointer  of a `JInt JsonNode`.
    ##
    ## Returns ``default`` if ``n`` is not a ``JInt``, or if ``n`` is nil.
    if n.isNil or n.kind != JInt: return nil
    else: return cast[ptr ChannelJson](cast[uint](n.num))[]





  #! Intercomm functions; ChannelJson; Main Channel [ msgtyp: int, msg: json ]
  proc addFeed*(icom: var InterCom, feedname:int)=
    ## add feed named feedname (int) to intercom and init feed
    when defined debugInfo_enabled: debugEcho "addFeed..........", feedname
    if not icom.hasKey(feedname):
      icom[feedname] = newTable[int, ChannelJson]()

  proc subscribe*(feed: var MainChannelJsonFeeds, thId: int, chan: var ChannelJson)=
    ## this proc is used in channel handler to add channel to feed
    feed[thId]= chan
    



  #[ proc subscribe*(icom: var InterCom, thId: int, chan: var ChannelJson):int=
    ## subscribe to main feed - 0
    ## send a message on intercom with proper json msg
    ## return error code from reply
    var testJson = newJObject()
    testJson.add("typ", newJInt(101)) #TODO 101 fixed - hard to overrride
    testJson.add("from", newJInt(thId))
    testJson.add("feed", newJInt(0))
    testJson.add("chanPtr", %(addr chan))
  
    when defined debugInfo_enabled: debugEcho "subscribing to > ", testJson
  
    icom[0].sendTo(0, $testJson)
    sleep(1)

    while chan[].peek() == 0:
      when defined debugInfo_enabled: debugEcho chan[].peek()
      sleep(1)

    var replyJ = chan[].recv()
    when defined debugInfo_enabled: debugEcho thId, " > ", replyJ
    var r = parseJson(replyJ)
    
    return r["r"].getInt() ]#



  proc subscribe*(icom: var InterCom, feed, thId: int, chan: var ChannelJson):int=
    ## subscribe to user-defined feed
    ## return error code from reply:
    ##   recommended reply from channel handler:
    ##     interCom[feedname].sendTo(msgfrom, """{ "r": 0 }""")
    var testJson = newJObject()
    testJson.add("typ", newJInt(101))
    testJson.add("from", newJInt(thId))
    testJson.add("feed", newJInt(feed))
    testJson.add("chanPtr", %(addr chan))
  
    when defined debugInfo_enabled: debugEcho "subscribing to > ", testJson
  
    icom[0].sendTo(0, $testJson)
    sleep(1)

    while chan[].peek() == 0:
      when defined debugInfo_enabled: debugEcho chan[].peek()
      sleep(1)

    var replyJ = chan[].recv()
    when defined debugInfo_enabled: debugEcho thId, " > ", replyJ
    var r = parseJson(replyJ)
    
    return r["r"].getInt()

  proc subscribe*(icom: var InterCom, thId: int, chan: var ChannelJson):int=
    ## subscribe to main feed - 0
    ## send a message on intercom with proper json msg
    ## return error code from reply:
    ##   recommended reply from channel handler:
    ##     interCom[feedname].sendTo(msgfrom, """{ "r": 0 }""")
    return subscribe(icom, 0, thId, chan)



##[ 
  var 
    i:int=64
    p:ptr int
    ui: uint

  i=112
  p=nil
  ui<--p
  p = addr i
  p-->ui
  p=nil
  ui-->p
  p[]=453
  echo i ]##

