# APPBASE

Appbase is a core application boilerplate,
with logging, inter-thread communication, and some support functions.  

(Appbase was extracted from stui, extended, genericised, and ported back)

the builded applications nim.cfg controlls wich components are enabled:
```
    --define:inputEventLoop_enabled # main HID event loop
    --define:mainChannelInt_enabled 
    --define:mainChannelString_enabled
    --define:mainChannelIntTalkback_enabled # sends ptr int, change int value to talk back
    --define:mainChannelIntChecked_enabled # sends int and ptr Channel[int] to talk back
    --define:mainChannelJsonChecked_enabled # aka InterCom
    --define:timedActions_enabled
```

appbase/mainChannel... .inc.nim files are boilerplates for Channel handling
appbase/myappbasetypes is the glue, where stui connected to appbase
appbase.mainloop template runs timers, channelhandlers and eventloop

stui_template.nim is derived from appbase template for stui
main.inc.nim is your programs main file, wich will be included in the boilerplate

## mainChannelJsonChecked aka Intercom

Its a Json channel. More precisely it is a table of Json Channels.  
A thread may pick a name (int), and register its channel to a feed (int).  
The main thread registers to [0][0] - at start.  
Functions like `broadcast` send messages to every feed member.  
`sendTo` searches for the recipient in all feeds, and sends to it exclusively.  

A simple test looks like this:  
`subscribe` send a json msg to main thread,  
wich registers the new channel via `mainChannelJson.inc.nim`, and sends back the errorcode: 
`interCom[feedname].sendTo(msgfrom, """{ "r": 0 }""")`

```nim
proc testJ2*(interCom: ptr InterCom){.thread.}=
  let
    mThreadId = 31

  var replyJChannel31 = new ChannelJson
  var testJson = newJObject()
  testJson.add("typ", newJInt(101))
  testJson.add("from", newJInt(mThreadId))
  testJson.add("feed", newJInt(0))
  testJson.add("chanPtr", %(addr replyJChannel31))

  echo mThreadId, testJson

  var icom = interCom[]
  echo "  [testJ2]  subscribe result > ", icom.subscribe(mThreadId, replyJChannel31)

#...........

var
  th31: Thread[ptr InterCom]
proc testJ3*()=

  th31.createThread(testJ2, addr interCom)
```

  
##### subscribe is a little bit overloaded:
it adds a channel to a feed.  

```nim
  proc subscribe*(feed: var MainChannelJsonFeeds, thId: int, chan: var ChannelJson)=
      feed[thId]= chan
```
however, if used from a thread, it sends a msg to main thread (101),  
wich then subscribes to the feed, and sends reply.  
`proc subscribe*(icom: var InterCom, thId: int, chan: var ChannelJson):int=`   
`proc subscribe*(icom: var InterCom, feed, thId: int, chan: var ChannelJson):int=`  


```nim
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

```


## mainChannelIntTalkback

appbase has 'checked' or 'talkback' enabled channels for communication,
so the thread can wait for operations to complete on variables, so
less segfault raises.

Channels are ref Channels - so they can be passed to submodules.
and they need the `[]` operator to get the channel inside.
plus if passed to a thread, two unboxing is needed `[][]` == `[ptr][ref]`.

```nim
    when defined mainChannelIntTalkback_enabled:
      ## a talkback channel sends a pointer to a mutable variable, eg int,
      ## and changes it after operation -> change can be checked, variable can be
      ## destroyed
      ## atomicInc(intPtr[])
      type McitChannel* = ref Channel[ptr int]
      var mainChannelIntTalkback = new McitChannel
      proc getMcitChannel*(): McitChannel = mainChannelIntTalkback #! <-- getter -----

      proc waitFor*(chan: var McitChannel, msg: var int)=
        var temp = msg
        open chan[]
        chan[].send(addr msg)
        while temp == msg:
          sleep(1)
```
```nim
  proc handleMainChannelIntTalkback()=
    var inbox = tryRecv( (mainChannelIntTalkback[]) ) #tuple[dataAvailable: bool, msg: TMsg]
    if inbox.dataAvailable:
      case inbox.msg[]:
        of 1:
            # do something here
            atomicInc(inbox.msg[]) # talk back - release variable
        of 256..int.high:
            var msg = unpackIntMsg(inbox.msg[].uint)
            # do something here
            atomicInc(inbox.msg[])
```
The following test uses `packIntMsg`, to store array[0..3, uint] into int.  
With this you are able to get a "hierarchy of messages" to decode from one simple int.  
```nim
proc testIntTalkBack*(mainChannelIntTalkback: ptr McitChannel){.thread.}=
  var 
    msg: int
    resp: int
    chan: McitChannel

  chan = mainChannelIntTalkback[]
  msg = packIntMsg([128.uint,242.uint,9.uint,64.uint]).int
  open chan[]
  chan[].send(addr msg)
  resp = msg
  echo "  {{testIntTalkBack}}   Sent...", msg

  while resp == msg:
    sleep(1)
    echo "  {{testIntTalkBack}}   Receive..."
  echo "  {{testIntTalkBack}}   Received mainChannelIntTalkback"

  msg = packIntMsg([128.uint,242.uint,9.uint,64.uint]).int
  chan.waitFor(msg)
  echo "  {{testIntTalkBack}}       Received waitFor mainChannelIntTalkback"


```

## APPBASE functions