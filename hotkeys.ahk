#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

if not A_IsAdmin
  Run *RunAs "%A_ScriptFullPath%"

; Workspace management
#include workspace.ahk

; Disable Windows Key launching start menu
LWin & vk07::return
LWin::return

; Always on Top
^+space:: winset, Alwaysontop, ,A

; Disable Page Up and Down keys
PgUp::Return
PgDn::Return

;------------------------------------------------------------------------
; Show hidden folders and files in Windows XP
;------------------------------------------------------------------------
; User Key: [HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
; Value Name: Hidden
; Data Type: REG_DWORD (DWORD Value)
; Value Data: (1 = show hidden, 2 = do not show)

^+h::GoSub,CheckActiveWindow

CheckActiveWindow:
  ID := WinExist("A")
  WinGetClass,Class, ahk_id %ID%
  WClasses := "CabinetWClass ExploreWClass"
  IfInString, WClasses, %Class%
    GoSub, Toggle_HiddenFiles_Display
Return

Toggle_HiddenFiles_Display:
  RootKey = HKEY_CURRENT_USER
  SubKey  = Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced

  RegRead, HiddenFiles_Status, % RootKey, % SubKey, Hidden

  if HiddenFiles_Status = 2
      RegWrite, REG_DWORD, % RootKey, % SubKey, Hidden, 1 
  else 
      RegWrite, REG_DWORD, % RootKey, % SubKey, Hidden, 2
  PostMessage, 0x111, 41504,,, ahk_id %ID% ; or Send {AppsKey}e
Return
