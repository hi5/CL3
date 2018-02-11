/*

Plugin            : Search history
Version           : 1.4

Searchable listbox 
Combined with Endless scrolling in a listbox http://www.autohotkey.com/forum/topic31618.html

History:
- 1.4 Merge items using F5
- 1.3 Replaced rudimentary editor with QEDlg()
      QEDlg() - pop-up editor by jballi, source via PM at autohotkey.com Feb 28th 2017
      Edit Library by jballi, source: https://autohotkey.com/boards/viewtopic.php?f=6&t=5063
      Add-On Functions (included in Edit library package)
      [QEDlg() not included in public release as code is not (yet) published]
- 1.2 Added option to Edit entry and update history (shortcut: f4)
- 1.1 Added option to yank (delete) entry directly from the listbox using ctrl-del (highlight item first)

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
Gui, Search:font, % dpi("s8")
Gui, Search:Add, Text, % dpi("x5 y8 w45 h15"), &Filter:
Gui, Search:Add, Edit, % dpi("gGetText vGetText x50 y5 w300 h20 +Left"),
Gui, Search:Add, Text, % dpi("x355 y8"), [ctrl+del] = yank (Remove) entry. [F4] = edit entry.
Gui, Search:Add, ListBox, % dpi("multi x5 y30 w585 h270 vChoice Choose") ChooseID, %StartList%
Gui, Search:Add, Button, % dpi("default hidden gSearchChoice"), OK ; so we can easily press enter
Gui, Search:Show, % dpi("h300 w595"), %GUITitle%
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
Gosub, SearchGetID
Gui, Search:Submit, Destroy
Sleep 100
Gosub, ClipboardHandler
id:="",ChooseID:=""
Return

SearchGetID:
id:=""
Gui, Search:Submit, NoHide
if (Choice = "")
	{
	 ControlGet, Choice, list, , ListBox1, A
	}
id:=Ltrim(SubStr(Choice,2,InStr(Choice,"]")-2),"0")
if (id = "")
	id:=1
ClipText:=History[id].text
Choice:=""
Return

SearchEditOK:
Gui, SearchEdit:Submit, Destroy
History[id,"text"]:=ClipText
If (id = 1)
	Clipboard:=ClipText
ClipText:=""
ChooseID:=ID
id:=""
Gosub, ^#h
Return

SearchEditCancel:
Gui, SearchEdit:Destroy
ChooseID:=""
Gosub, ^#h
Return

#IfWinActive, CL3Search

F5:: ; merge items
Gui, Search:Submit
ClipText:="",Removeids:=""
Loop, parse, choice, |
	{
	 if (A_LoopField = "")
		continue
	 id:=Ltrim(SubStr(A_LoopField,2,InStr(A_LoopField,"]")-2),"0")
	 if (id = "")
		 id:=1
	 ClipText.=History[id].text "`n"
	 Removeids:=id "," Removeids
	}
Loop, parse, Removeids, CSV
	History.Remove(A_LoopField)
History.Insert(1,{"text":ClipText,"icon": "res\" iconA })
ClipText:="",Removeids:=""
Return

F4::
Gosub, SearchGetID
; not public
#include *i %A_ScriptDir%\plugins\MyQEDLG-Search.ahk
Gui, Search:Destroy

Gui, SearchEdit:Destroy
Gui, SearchEdit:Add, Text, x5 y8 w100 h15, Edit this entry:
Gui, SearchEdit:Add, Edit, vClipText x5 y25 w600 h300, %ClipText%
Gui, SearchEdit:Add, Button, gSearchEditOK w100, OK
Gui, SearchEdit:Add, Button, xp+110 yp gSearchEditCancel w100, Cancel
Gui, SearchEdit:Show, w610 h360, CL3 Edit Entry [ID: %ID%]
Return

^Del::
Gosub, SearchGetID
Gui, Search:Submit, Destroy	
History.Remove(id)
id:="",ClipText:="",ChooseID:=""
Gosub, ^#h
Return

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
	 ;SendMessage, 0x18b, 0, 0, ListBox1, %GUITitle%  ; 0x18b is LB_GETCOUNT (for a ListBox).
	 ;SendMessage, 390, (Errorlevel-1), 0, ListBox1, %GUITitle%  ; LB_SETCURSEL = 390
	 ControlSend, ListBox1, ^{end}, %GUITitle%
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
	; SendMessage, 390, 0, 0, ListBox1, %GUITitle%  ; LB_SETCURSEL = 390 - position 'one'
	ControlSend, ListBox1, ^{home}, %GUITitle%
Return
#IfWinActive

SearchGuiClose:
SearchGuiEscape:
Gui, Search:Destroy
ChooseID:=""
Return

; not public
#include *i %A_ScriptDir%\plugins\MyQEDLG.ahk
