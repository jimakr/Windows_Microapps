#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

Numpad6::
	Send →
return

Numpad8::
	Send ∧
return

Numpad2::
	Send ∨
return

Numpad4::
	Send ¬
return

Numpad5::
	Send ≡
return

Numpad7::
	Send false
return

Numpad9::
	Send true
return

Numpad1::
	Send ∀
return

Numpad3::
	Send ∃
return