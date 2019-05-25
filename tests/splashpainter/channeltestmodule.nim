import appbase, appbase/myappbasetypes, threadpool, tables, os, json, 
      appbase/intchannelutils

var 
  app*: MyApp
  interCom*: InterCom
  mainChannelIntTalkback*: McitChannel
  mainChannelString*: McsChannel
  mainChannelLog*: LogChannel

#!-------------
let
  mThreadId* = 3


var replyJChannel = new ChannelJson

proc testJ1*()=

  #open replyJChannel[]

  #open mainChannelLog[]
  when defined logger_enabled: mainChannelLog[].send("N [testJ1] addr: " & $ cast[uint](addr(replyJChannel)) )

  var testJson = newJObject()
  testJson.add("typ", newJInt(101)) # 101: current code for add channel to intercom - see mainChannelJson.inc.nim
  testJson.add("from", newJInt(mThreadId)) # sender. and this id will be registered i intercom
  testJson.add("feed", newJInt(0)) # the feed/branch to register into
  testJson.add("chanPtr", %(addr replyJChannel))
  #when defined logger_enabled: mainChannelLog[].send("N" &  $ mThreadId & $(type interCom[0]) & $ app.threadId)
  interCom[0].sendTo(0, $testJson)
  when defined logger_enabled: mainChannelLog[].send("N [testJ1]")

#!------------------------------------------------------------------------------

proc testJ2*(interCom: ptr InterCom){.thread.}=
  let
    mThreadId = 31

  var replyJChannel31 = new ChannelJson
  var testJson = newJObject()
  testJson.add("typ", newJInt(101))
  testJson.add("from", newJInt(mThreadId))
  testJson.add("feed", newJInt(0))
  testJson.add("chanPtr", %(addr replyJChannel31))

  #when defined logger_enabled: mainChannelLog[].send("N" & $ mThreadId & $ testJson)

  var icom = interCom[]
  #when defined logger_enabled: mainChannelLog[].send("N  [testJ2]  subscribe result > " & $ 
  discard icom.subscribe(mThreadId, replyJChannel31) # TODO LOG

#...........

var
  th31: Thread[ptr InterCom]
proc testJ3*()=

  th31.createThread(testJ2, addr interCom)

#!------------------------------------------------------------------------------

proc testIntTalkBack*(args:tuple[mcit: ptr McitChannel, mclog: ptr LogChannel]){.thread.}=
  #[ let
    mThreadId = 41 ]#

  var 
    msg: int
    resp: int
    chan: McitChannel
    logchan: LogChannel
    (mainChannelIntTalkback, mclog) = args

  logchan = mclog[]
  #open logchan[]

  chan = mainChannelIntTalkback[]
  msg = packIntMsg([128.uint,242.uint,9.uint,64.uint]).int
  #open chan[]
  chan[].send(addr msg)
  resp = msg
  
  when defined logger_enabled: logchan[].send("N  {{testIntTalkBack}}   Sent..." & $ msg)
  when defined logger_enabled: logchan[].send( "D  {{testIntTalkBack}}   peek: " & $ chan[].peek())

  while resp == msg:
    sleep(1)
  when defined logger_enabled: logchan[].send( "N  {{testIntTalkBack}}   Received mainChannelIntTalkback")

  msg = packIntMsg([255.uint,44.uint,0.uint,128.uint]).int
  chan.waitFor(msg)
  when defined logger_enabled: logchan[].send("D  {{testIntTalkBack}}       Received waitFor mainChannelIntTalkback")


#...................................

var
  th41: Thread[tuple[mcit: ptr McitChannel, mclog: ptr LogChannel]]

proc testMainChannelIntTalkback*()=

  th41.createThread(testIntTalkBack, (mcit: addr mainChannelIntTalkback, mclog: addr mainChannelLog) )

#!------------------------------------------------------------------------------


proc testMcsChannel*(args:tuple[mcs: ptr McsChannel, mclog: ptr LogChannel]){.thread.}=
  #[ let
    mThreadId = 51 ]#

  var 
    msg: string = "hello"
    (mainChannelString, logchan) = args

  #open logchan[][]

  #open mainChannelString[][]
  mainChannelString[][].send(msg)
  when defined logger_enabled: logchan[][].send( "N  $$$ testMcsChannel $$$   Sent..." & msg)
  #when defined logger_enabled: notice( "  $$$ testMcsChannel $$$   peek: ",mainChannelString[][].peek())

  #[ sleep(1500)
  msg = "quit"
  mainChannelString[][].send(msg)
  when defined logger_enabled: logchan[][].send( "N  $$$ testMcsChannel $$$   Sent..." & msg) ]#

var
  thStr51: Thread[tuple[mcs: ptr McsChannel, mclog: ptr LogChannel]]

proc testMainChannelString*()=
  thStr51.createThread(testMcsChannel,(mcs: addr mainChannelString, mclog: addr mainChannelLog))