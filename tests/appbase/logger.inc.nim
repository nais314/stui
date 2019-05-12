# logger wrapper
# used logger must support nim logger for source code syntax compatibility
# should declare fileLog at least

# some defaults
import os
const logDir = getHomeDir() & ".log"
if not dirExists(logDir):
  createDir(logDir)
  #TODO not all cases are covered ...

#! init your logger here
import logging
var fileLog = newRollingFileLogger(logDir & DirSep & "messages.log", fmtStr=verboseFmtStr)
logging.addHandler(fileLog)