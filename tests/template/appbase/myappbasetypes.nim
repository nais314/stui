import stui/appbase/appbasetypes
export appbasetypes

#! CREATE INHERIED APP TYPE HERE, FOR USE
import stui
type
  AppFlags* = enum #! WRITE YOUR FLAGS
    ## appbase App has 12 int flags in .flags*
    quitFlag,
    debugFlag,
    threadsFlag, # threads counter for graceful quit
    scenarioFlag # eg maintenence

  MyApp* = stui.App

#-------------------------------------------------------------------------------
type 
  InputLoopEvent* = KMEvent #! replace this with your type - now it is stuis KMEvent