import os, locks, times, tables
import appbase/appbasetypes

#[ type
    EventRoot* = object of RootObj#dummy base

    TimedAction* = tuple[name:string,interval:float,action:proc():void,lastrun:float] # epochTime:float
    
    # AppBase:------------------------------
    #   extend with your needed fields: MyApp* = ref object of AppBase
    AppBase* = ref object of RootObj
        listeners*: seq[tuple[name:string, actions: seq[proc():void]]]
        timers*: seq[TimedAction] #seq[tuple[name:string,interval:float,action:proc()]]

    # Main Channel [ msgtyp: int, msg: json ]
    ChannelJson* = Channel[tuple[msgtyp:int, msg:string]]
    MainChannelJsonFeeds* = Table[int, ChannelJson] # TH id, Json
    InterCom* = Table[string, MainChannelJsonFeeds] ]#

#-------------------------------------------------------------------------------
#[ # Intercomm functions; ChannelJson; Main Channel [ msgtyp: int, msg: json ]
proc subscribe*(feed: var MainChannelJsonFeeds, thId: int, chan:ChannelJson)=
    feed[thId]= chan

proc broadcast*(feed: var MainChannelJsonFeeds, msgtyp:int, msg:string)=
    for thId, listener in feed:
        feed[thId].send((msgtyp:msgtyp, msg:msg)) ]#

#-------------------------------------------------------------------------------
# todo: make a paralell version:
proc runTimers*(this:AppBase)=
  var time = epochTime()
  if this.timers.len > 0:
    for iT in 0..this.timers.high:
        if time - this.timers[iT].lastrun >= this.timers[iT].interval:
            this.timers[iT].action()
            this.timers[iT].lastrun = time
        sleep(0)

#-------------------------------------------------------------------------------


proc addEventListener*(app:AppBase, evtname:string, fun:proc():void)=
  var exists = false
  var newListener: tuple[name:string, actions: seq[proc():void]]
  for i in 0..app.listeners.high:
      if app.listeners[i].name == evtname:
          app.listeners[i].actions.add(fun)
          exists = true
  if not exists:
      newListener.name = evtname
      newListener.actions = @[]
      newListener.actions.add(fun)
      app.listeners.add(newListener)


proc removeEventListener*(app:AppBase, evtname:string, fun:proc():void)=
  for i in 0..app.listeners.high:
      if app.listeners[i].name == evtname:
          for j in 0..app.listeners[i].actions.high:
              if app.listeners[i].actions[j] == fun:
                  app.listeners[i].actions.del(j)

proc trigger*(app:AppBase, evtname:string )=
  for i in 0..app.listeners.high:
      if app.listeners[i].name == evtname:
          for j in 0..app.listeners[i].actions.high:
              app.listeners[i].actions[j]()


template mainLoop*[T](app:T, eventhandler: untyped)=
    while true:

        when defined timedActions_enabled: app.runTimers()


        when defined mainChannelLog_enabled: handleLogChannel()
        when defined mainChannelInt_enabled: handleMainChannelInt()

        when defined mainChannelIntTalkback_enabled: handleMainChannelIntTalkback()

        when defined mainChannelIntChecked_enabled: handleMainChannelIntChecked()
        when defined mainChannelString_enabled: handleMainChannelString()
        when defined mainChannelJsonChecked_enabled: handleMainChannelJsonChecked()
        
        #......
        when defined inputEventLoop_enabled:
          if inputLoopEventFlowVar.isReady():#! YOU define it in the body of template: 

              eventhandler #! YOUR event handler that handles inputLoopEventFlowVar


        sleep(0) #! cpuRelax

