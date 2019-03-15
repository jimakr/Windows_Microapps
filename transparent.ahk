#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#Persistent
#SingleINstance force

 WinSet, Transparent, 200, ahk_class Shell_TrayWnd
SetTimer, WatchForMenu, 5
SetTimer, WatchForExplorer, 5
return  ; End of auto-execute section.

WatchForExplorer:
IfWinExist, ahk_class CabinetWClass
    WinSet,  Transparent, 235
IfWinExist, ahk_exe Notepad.exe
    WinSet,  Transparent, 225
IfWinExist, ahk_exe BitTorrent.exe
    WinSet,  Transparent, 225
return


WatchForMenu:
DetectHiddenWindows, on  ; Might allow detection of menu sooner.
IfWinExist, ahk_class #32768
    WinSet, Transparent, 235  ; Uses the window found by the above line
return
