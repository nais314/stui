# logger wrapper
# used logger must support nim logger for source code syntax compatibility
# should declare fileLog at least

# some defaults
import os
const logDir = getHomeDir() & ".log"
if not dirExists(logDir):
  createDir(logDir)
  #TODO not all cases are covered ...

#! init your logger here <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
import logging
var fileLog = newRollingFileLogger(filename = logDir & DirSep & "messages.log",
    fmtStr=verboseFmtStr,
    levelThreshold = lvlDebug)
logging.addHandler(fileLog)

#!━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# log channel for threads:
var mainChannelLog = getLogChannel()
mainChannelLog[].open()

proc handleLogChannel()=
  #mainChannelLog[].open()
  var inbox = tryRecv( (mainChannelLog[]) ) #tuple[dataAvailable: bool, msg: TMsg]
  if inbox.dataAvailable:
    case inbox.msg[0]:
    of 'N':
      notice inbox.msg
    of 'D':
      debug inbox.msg
    of 'W':
      warn inbox.msg
    of 'E':
      error inbox.msg
    else:
      notice inbox.msg
  #sleep(0)