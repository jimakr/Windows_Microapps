Gui, Color,   000006  
Gui +LastFound +AlwaysOnTop +ToolWindow
WinSet, TransColor,   000006  
Gui -Caption
global option := 1
global opt := 1
global xpos :=0
global ypos :=0

Gui, Add, Picture, x0 y0 w1920 h1050 +BackgroundTrans, styx.png 
Loop, Read, C:\Users\jim\Desktop\data.txt   ; This loop retrieves each line from the file, one at a time.
{
    global ArrayCount += 1  ; Keep track of how many items are in the array.
    Array%ArrayCount% := A_LoopReadLine  ; Store this line in the next array element.
	xpos := SubStr(Array%ArrayCount%, 1 ,3)
	ypos := SubStr(Array%ArrayCount%, 5 ,3)
	path := SubStr(Array%ArrayCount%, 9)
	;MsgBox, 0, , %xpos% "   " %ypos% "   " %path%
	Gui, Add, Picture, gClick x%xpos% y%ypos% w110 h110 +BackgroundTrans , %  path
}
Gui, Show, x0 y55 h1031 w1898, New GUI Window
return

GuiDropFiles:
	StringSplit, F, A_GuiEvent, `n
	path := SubStr(F1, -2)
	;MsgBox, 0, , %path%
	if (path = "txt") {
		FileRead, Text, %F1%
		if (Text = "key") {
			option := !option
			;MsgBox, 0, , movenow
		} 
	} else {
		MouseGetPos, xpos, ypos 
	;MsgBox, 0, , added %F1%
	
		Gui, Add, Picture, gClick  x%xpos% y%ypos% w110 h110 HWNDhedit1 +BackgroundTrans  , % F1
		GuiControl, MoveDraw, %hedit1%, % "x" xpos "y" ypos "w110" "h110"
	}
Return

Click(Hwnd)
{ 
	if (option){
		GuiControlGet, Value , , %Hwnd%
		Run, %Value%
		ExitApp
	}else{
		Movelement(hwnd)
	}
}

Movelement(hwnd)
{
	;MsgBox, 0, , move started
	loop{

GetKeyState, state, LButton,P
if state = U
{
	;MsgBox, 0, , released
	break
	
}
	MouseGetPos, xpos, ypos 
	GuiControl, MoveDraw, %Hwnd%, % "x" xpos "y" ypos "w110" "h110" ;

}
}

storepos:
MouseGetPos, xpos, ypos 
return

GuiClose:
GuiEscape:
ExitApp