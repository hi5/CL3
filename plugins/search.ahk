/*

Plugin            : Search history
Version           : 1.0
CL3 version       : 1.2

Searchable listbox 
Combined with Endless scrolling in a listbox http://www.autohotkey.com/forum/topic31618.html

*/


^#h::
GUITitle=CL3Search

StartList:=""
for k, v in History
	{
	 add:=v.text	
	 stringreplace, add, add, |,,All
	 stringreplace, add, add, `n,%A_Space%,All
	 StartList .= "[" SubStr("00" A_Index,-2) "] " Add "|"
	}

Gui, Search:Destroy
Gui, Search:Add, Text, x5 y8 w45 h15, &Filter:
Gui, Search:Add, Edit, gGetText vGetText x50 y5 w440 h20 +Left,
Gui, Search:Add, ListBox, x5 y30 w585 h270 vChoice, %StartList%
Gui, Search:Add, Button, default hidden gSearchChoice, OK ; so we can easily press enter
Gui, Search:Show, h300 w595, %GUITitle%
Return

GetText:
Gui, Search:Submit, NoHide
Loop, Parse, StartList, |
	{
	 re:="iUms)" GetText
	 if InStr(GetText,A_Space) ; prepare regular expression to ensure search is done independent on the position of the words
		re:="iUms)(?=.*" RegExReplace(GetText,"iUms)(.*)\s","$1)(?=.*") ")"
	 if RegExMatch(A_LoopField,re) 
		UpdatedStartList .= A_LoopField "|"
	}
GuiControl, Search:, ListBox1, |%UpdatedStartList%
GetText=
UpdatedStartList=
Return

SearchChoice:
Gui, Search:Submit, NoHide
if (Choice = "")
	{
	 ControlFocus, ListBox1, A
	 ControlSend, ListBox1, {down}, A
	}
Gui, Search:Submit, Destroy
id:=Ltrim(SubStr(Choice,2,InStr(Choice,"]")-2),"0")
ClipText:=History[id].text
Sleep 100
Gosub, ClipboardHandler
id:=""
Return

#IfWinActive, CL3Search
Up::
SendMessage, 0x188, 0, 0, ListBox1, %GUITitle%  ; 0x188 is LB_GETCURSEL (for a ListBox).
PreviousPos:=ErrorLevel+1
ControlSend, ListBox1, {Up}, %GUITitle%
SendMessage, 0x18b, 0, 0, ListBox1, %GUITitle%  ; 0x18b is LB_GETCOUNT (for a ListBox).
ItemsInList:=ErrorLevel
SendMessage, 0x188, 0, 0, ListBox1, %GUITitle%  ; 0x188 is LB_GETCURSEL (for a ListBox).
ChoicePos:=ErrorLevel+1
If (ChoicePos = PreviousPos)
	{
	 SendMessage, 0x18b, 0, 0, ListBox1, %GUITitle%  ; 0x18b is LB_GETCOUNT (for a ListBox).
	 SendMessage, 390, (Errorlevel-1), 0, ListBox1, %GUITitle%  ; LB_SETCURSEL = 390
	}
Return

Down::
SendMessage, 0x188, 0, 0, ListBox1, %GUITitle%  ; 0x188 is LB_GETCURSEL (for a ListBox).
PreviousPos:=ErrorLevel+1
SendMessage, 0x18b, 0, 0, ListBox1, %GUITitle%  ; 0x18b is LB_GETCOUNT (for a ListBox).
ItemsInList:=ErrorLevel
ControlSend, ListBox1, {Down}, %GUITitle%
SendMessage, 0x188, 0, 0, ListBox1, %GUITitle%  ; 0x188 is LB_GETCURSEL (for a ListBox).
ChoicePos:=ErrorLevel+1
If (ChoicePos = PreviousPos)
	SendMessage, 390, 0, 0, ListBox1, %GUITitle%  ; LB_SETCURSEL = 390 - position 'one'
Return
#IfWinActive

SearchGuiClose:
SearchGuiEscape:
Gui, Search:Destroy
Return
