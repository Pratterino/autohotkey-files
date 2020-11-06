#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
; #SingleInstance ; Override active instance of this script. Singleton.

SRC_1 := 6
SRC_2 := 5

; From: https://autohotkey.com/board/topic/96884-change-monitor-input-source/

; Finds monitor handle
getMonitorHandle()
{
  ; Initialize Monitor handle
  hMon := DllCall("MonitorFromPoint"
    , "int64", 0 ; point on monitor
    , "uint", 1) ; flag to return primary monitor on failure

    
  ; Get Physical Monitor from handle
  VarSetCapacity(Physical_Monitor, 8 + 256, 0)

  DllCall("dxva2\GetPhysicalMonitorsFromHMONITOR"
    , "int", hMon   ; monitor handle
    , "uint", 1   ; monitor array size
    , "int", &Physical_Monitor)   ; point to array with monitor

  return hPhysMon := NumGet(Physical_Monitor)
}

destroyMonitorHandle(handle)
{
  DllCall("dxva2\DestroyPhysicalMonitor", "int", handle)
}

; Used to change the monitor source
; HDMI = 5,6
setMonitorInputSource(source)
{
  handle := getMonitorHandle()
  DllCall("dxva2\SetVCPFeature"
    , "int", handle
    , "char", 0x60 ;VCP code for Input Source Select
    , "uint", source)
  destroyMonitorHandle(handle)
}

; Gets Monitor source
getMonitorInputSource()
{
  handle := getMonitorHandle()
  DllCall("dxva2\GetVCPFeatureAndVCPFeatureReply"
    , "int", handle
    , "char", 0x60 ;VCP code for Input Source Select
    , "Ptr", 0
    , "uint*", currentValue
    , "uint*", maximumValue)
  destroyMonitorHandle(handle)
  return currentValue
}

#IfWinActive
Pause::
^Home::
    setMonitorInputSource(6)
    return

^Insert::
    setMonitorInputSource(5)
    return