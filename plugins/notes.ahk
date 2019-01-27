/*

Plugin            : Notes
Purpose           : Append the current clipboard to "Note files" (plain text).
                    see docs\notes.md
Version           : 1.0
CL3 version       : v1.94

History:
- 1.0 initial version

*/

NotesMenuSetup:

NotesMenu:=[]
FileRead, Notes, %A_ScriptDir%\ClipData\Notes\Notes.txt
Notes:=RegExReplace(Notes, "\R+\R", "`r`n")          ; remove empty lines
Notes:=RegExReplace(Notes "`n", "m`a)(?=^\s*;).*\R") ; remove commented lines
Notes:=StrReplace(Notes,"%A_ScriptDir%",A_ScriptDir)
Notes:=StrReplace(Notes,"%A_MyDocuments%",A_MyDocuments)
Notes:=StrReplace(Notes,"%A_Desktop%",A_Desktop)
Notes:=StrReplace(Notes,"%A_DesktopCommon%",A_DesktopCommon)
Loop, parse, Notes, `n, `r
	{
	 if (A_LoopField = "")
		continue
	 NotesMenuTemp:=StrSplit(A_LoopField,"|")
	 NotesMenu.Push(NotesMenuTemp[2])
	 If !NotesMenuTemp[3]
		NotesMenuTemp[3]:=A_ScriptDir "\res\icon-a.ico"
	 Menu, Notes, Add, % "&" A_Index ". " NotesMenuTemp[1], NotesMenuHandler
	 try
		Menu, Notes, Icon, % "&" A_Index ". " NotesMenuTemp[1], % NotesMenuTemp[3]
	 catch
		Menu, Notes, Icon, % "&" A_Index ". " NotesMenuTemp[1], %A_ScriptDir%\res\icon-a.ico
	}
NotesMenuTemp:=""	
Return

;#n::
hk_notes:
WinGetPos, MenuX, MenuY, , , A
MenuX+=A_CaretX
MenuX+=20
MenuY+=A_CaretY
MenuY+=10
If (A_CaretX <> "")
	Menu, Notes, Show, %MenuX%, %MenuY%
else
	Menu, Notes, Show
Return

NotesMenuHandler:
NoteText:=""
FileRead, NoteText, %A_ScriptDir%\ClipData\Notes\NotesTemplate.txt
If !InStr(NoteText,"@clipboard@") ; be sure we can insert the clipboard
	NoteText .= "@clipboard@"
If InStr(NoteText,"@NoteTime=")
	{
	 RegExMatch(NoteText,"iU)\@NoteTime=\K.*\@",NoteTime)
	 FormatTime, NoteTimeStamp, %A_Now%, % Trim(NoteTime,"@")
	}

If InStr(NoteText,"@NoteUri@")
	{
	 NoteUri:=""
	 NoteUri:=GetActiveBrowserURL()
	 Sleep 50
	 if !NoteUri
		WinGetTitle, NoteUri, A
	}

NoteText:=RegExReplace(NoteText,"iU)\@NoteTime=.*\@",NoteTimeStamp)
NoteText:=StrReplace(NoteText,"@NoteUri@",NoteUri)
NoteText:=StrReplace(NoteText,"@clipboard@",Clipboard)

FileAppend, % NoteText, % NotesMenu[A_ThisMenuItemPos]
NoteText:="",NoteUri:="",NoteTime:="",NoteTimeStamp:=""
Return
