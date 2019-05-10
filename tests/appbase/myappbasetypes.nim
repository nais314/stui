import appbase/appbasetypes
export appbasetypes

#! CREATE INHERIED APP TYPE HERE, FOR USE
import stui
type 
  MyApp* = stui.App

#-------------------------------------------------------------------------------
type 
  InputLoopEvent* = KMEvent #! replace this with your type

#-------------------------------------------------------------------------------
#! FLAGS
when defined mainFlags_enabled:
    type 
      Flags* = enum #! WRITE YOUR FLAGS
        quitFlag,
        debugFlag,
        threadsFlag, # threads counter for graceful quit
        scenarioFlag # eg maintenence

      MainFlags* = ref array[Flags, int]

    var flags = new(MainFlags)
    proc getMainFlags*():MainFlags = flags
    #? atomicInc(memLoc: var int; x: int = 1): int

#-------------------------------------------------------------------------------