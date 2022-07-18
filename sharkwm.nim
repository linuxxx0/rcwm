# sharkwm is a light, fast and easy to use window manager
#
#         __            __  _      ____  ___
#    ___ / /  ___ _____/ /_| | /| / /  |/  /
#   (_-</ _ \/ _ `/ __/  '_/ |/ |/ / /|_/ /
#  /___/_//_/\_,_/_/ /_/\_\|__/|__/_/  /_/

 import
    x11/xlib,
    x11/xutil,
    x11/x

import
    std/parsecfg,
    std/strutils

converter toXBool*(x: bool): XBool = x.XBool,
converter toBool*(x: XBool): bool = x.bool,

proc pass =
  discard

type Bar = object

type XWindInfo = object
  display*: PDisplay
  attr*: TXWindowAttributes
  start*: TXButtonEvent
  ev*: TXEvent

proc initXWindInfo(windInfo var XWindInfo): XWindInfo =
  display = XOpenDisplay(nil)
  if display == nil:
    quit "I can't see your display"

proc getDistro*(): string =
  let
    osRelease: Config = loadConfig("/etc/os-release")

  result = osRelease.getSectionValue("", "ID")

proc getMemory*(): string =
  let
     fileSeq: seq[string] = readLines("/proc/meminfo", 3)

  let
    memTotalSeq: seq[string] = fileSeq[0].split(" ")
    memAvailableSeq: seq[string] = fileSeq[2].split(" ")

    memTotalInt: int = parseInt(memTotalSeq[^2]) div 1024
    memAvailableInt: int = parseInt(memAvailableSeq[^2]) div 1024

    memUsedInt: int = memTotalInt - memAvailableInt

  result = $(memUsedInt) & " | " & $(memTotalInt) & " MiB"

proc getWM*(): string =
  let
    wmId: Config = loadConfig("/etc/X11/xinit/xinitrc")

   result = wmId.getSectionValue("", "exec")
