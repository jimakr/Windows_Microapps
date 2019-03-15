#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
#SingleInstance force
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


;this script had to automate the process of selection because changing desktop.ini did not update the icon after even through manual update.


F1:: ;hotkey to search for icon
	sel := Explorer_GetSelected() ;get the selected element open in file explorer
	a:="\"
	StringTrimLeft, foldername, sel, InStr(sel,a,false,0) ;get folder name
	IfNotExist, %sel%\icon.ico  ;if there isn't an icon already inside search for a new one
	{	
	Run C:\Program Files\Mozilla Firefox\firefox.exe "https://www.google.com/search?tbm=isch&q=%foldername% icon" ;google image search
	clipboard =  ; Start off empty to allow ClipWait to detect when the text has arrived.
	ClipWait  ; Wait for the clipboard to contain text.
	UrlDownloadToFile, %clipboard% , a ;download icon name it "a"
	Sleep, 1000 ;sleep to allow detection
	;resize and convert format
	Run cmd /c "convert -resize 256x256 a "%sel%\icon.ico"", ,hide 
	}
	Sleep, 1000
	IfExist, %sel%\icon.ico ;check everything went okey
	{ 
	DetectHiddenWindows, on 
	Run, properties "%sel%", ,hide ;open properties
	WinWait ahk_class #32770
	WinHide ;hide the window so user won't get distracted
	Sleep, 1000
	SendMessage, 0x1330, 4,, SysTabControl321,ahk_class #32770  ;send the message to the window to press the right buttons
	sleep 1000
	PostMessage, 0x201,,, Button7,ahk_class #32770
	sleep 100
	PostMessage, 0x202,,, Button7,ahk_class #32770,,,,20
	clipboard =  "%sel%\icon.ico"
	WinWait Change Icon for %foldername% Folder
	WinHide Change Icon for %foldername% Folder
	Sleep 1000
	SendMessage, 0x302,,, Edit1,Change Icon for %foldername% Folder
	Sleep, 1000
	PostMessage, 0x201,,, Button3,Change Icon for %foldername% Folder
	PostMessage, 0x202,,, Button3,Change Icon for %foldername% Folder,,,,200
	Sleep, 1000
	PostMessage, 0x201,,, Button3,Change Icon for %foldername% Folder
	PostMessage, 0x202,,, Button3,Change Icon for %foldername% Folder,,,,20
	Sleep 1000
	PostMessage, 0x201,,, Button8,ahk_class #32770
	PostMessage, 0x202,,, Button8,ahk_class #32770,,,,20
	Run attrib +h "%sel%\icon.ico", ,hide ;hide the icon inside the folder
	WinActivate ,ahk_class CabinetWClass ;switch to file explorer
	Send {F5} ;refresh in order to see the new icon
}
IfNotExist, %sel%\icon.ico 
{
	MsgBox "error icon file not copied"
}
return

;an imported library for reading from file explorer
	
/*
	Library for getting info from a specific explorer window (if window handle not specified, the currently active
	window will be used).  Requires AHK_L or similar.  Works with the desktop.  Does not currently work with save
	dialogs and such.
	
	
	Explorer_GetSelected(hwnd="")   - paths of target window's selected items
	Explorer_GetAll(hwnd="")        - paths of all items in the target window's folder
	Explorer_GetPath(hwnd="")       - path of target window's folder
	
	example:
		F1::
			path := Explorer_GetPath()
			all := Explorer_GetAll()
			sel := Explorer_GetSelected()
			MsgBox % path
			MsgBox % all
			MsgBox % sel
		return
	
	Joshua A. Kinnison
	2011-04-27, 16:12
*/

Explorer_GetPath(hwnd="")
{
	if !(window := Explorer_GetWindow(hwnd))
		return ErrorLevel := "ERROR"
	if (window="desktop")
		return A_Desktop
	path := window.LocationURL
	path := RegExReplace(path, "ftp://.*@","ftp://")
	StringReplace, path, path, file:///
	StringReplace, path, path, /, \, All 
	
	; thanks to polyethene
	Loop
		If RegExMatch(path, "i)(?<=%)[\da-f]{1,2}", hex)
			StringReplace, path, path, `%%hex%, % Chr("0x" . hex), All
		Else Break
	return path
}
Explorer_GetAll(hwnd="")
{
	return Explorer_Get(hwnd)
}
Explorer_GetSelected(hwnd="")
{
	return Explorer_Get(hwnd,true)
}

Explorer_GetWindow(hwnd="")
{
	; thanks to jethrow for some pointers here
    WinGet, process, processName, % "ahk_id" hwnd := hwnd? hwnd:WinExist("A")
    WinGetClass class, ahk_id %hwnd%
	
	if (process!="explorer.exe")
		return
	if (class ~= "(Cabinet|Explore)WClass")
	{
		for window in ComObjCreate("Shell.Application").Windows
			if (window.hwnd==hwnd)
				return window
	}
	else if (class ~= "Progman|WorkerW") 
		return "desktop" ; desktop found
}
Explorer_Get(hwnd="",selection=false)
{
	if !(window := Explorer_GetWindow(hwnd))
		return ErrorLevel := "ERROR"
	if (window="desktop")
	{
		ControlGet, hwWindow, HWND,, SysListView321, ahk_class Progman
		if !hwWindow ; #D mode
			ControlGet, hwWindow, HWND,, SysListView321, A
		ControlGet, files, List, % ( selection ? "Selected":"") "Col1",,ahk_id %hwWindow%
		base := SubStr(A_Desktop,0,1)=="\" ? SubStr(A_Desktop,1,-1) : A_Desktop
		Loop, Parse, files, `n, `r
		{
			path := base "\" A_LoopField
			IfExist %path% ; ignore special icons like Computer (at least for now)
				ret .= path "`n"
		}
	}
	else
	{
		if selection
			collection := window.document.SelectedItems
		else
			collection := window.document.Folder.Items
		for item in collection
			ret .= item.path "`n"
	}
	return Trim(ret,"`n")
}
