/*

Script      : CL3 ( = CLCL CLone ) - AutoHotkey 1.1+ (Ansi and Unicode)
Version     : 1.4
Author      : hi5
Purpose     : A lightweight clone of the CLCL clipboard caching utility which can be found at
              http://www.nakka.com/soft/clcl/index_eng.html written in AutoHotkey 
Source      : https://github.com/hi5/CL3

Features:
- Captures text only
- Limited history (18 items+26 items in secondary menu)
  (does remember more entries in XML history file though)
- Delete entries from history
- No duplicate entries in clipboard (automatically removed)
- Templates: simply textfiles which are read at start up
- Plugins: AutoHotkey functions (scripts) defined in seperate files
  v1.2: Search and Slots for quick pasting
  v1.3: Cycle through clipboard history, paste current clipboard as plain text
  v1.4: AutoReplace define find/replace rules to modify clipboard before adding it the clipboard

See readme.md for more info and documentation on plugins and templates.

*/

; General script settings
#SingleInstance, Force
SetBatchlines, -1
SendMode, Input
SetWorkingDir, %A_ScriptDir%
MaxHistory:=150
name:="CL3 "
version:="v1.4"
ScriptClip:=1
Templates:=[]
Error:=0

iconA:="icon-a.ico"
iconC:="icon-c.ico"
iconS:="icon-s.ico"
iconT:="icon-t.ico"
iconX:="icon-x.ico"
iconY:="icon-y.ico"
iconZ:="icon-z.ico"

; tray menu
Menu, Tray, Icon, res\cl3.ico
Menu, tray, Tip , %name% %version%
Menu, tray, NoStandard
Menu, tray, Add, %name% %version%, DoubleTrayClick
Menu, tray, Default, %name% %version%
Menu, tray, Add, 
Menu, tray, Add, &Reload this script, TrayMenuHandler
Menu, tray, Add, &Edit this script,   TrayMenuHandler
Menu, tray, Add, 
Menu, tray, Add, &Suspend Hotkeys,    TrayMenuHandler
Menu, tray, Add, &Pause Script, 	  TrayMenuHandler
Menu, tray, Add, 
Menu, tray, Add, Exit, 				  SaveSettings

Menu, ClipMenu, Add, TempText, MenuHandler
Menu, SubMenu1, Add, TempText, MenuHandler
Menu, SubMenu2, Add, TempText, MenuHandler
Menu, SubMenu3, Add, TempText, MenuHandler
Menu, SubMenu4, Add, TempText, MenuHandler

; load clipboard history and templates
IfNotExist, History.xml
	Error:=1

Try
	{
	 XA_Load("History.xml") ; the name of the variable containing the array is returned 
	}
Catch
	{
	 Error:=1
	}

If (Error = 1)
	{
	 FileCopy, res\history.bak.txt, history.xml, 1
	 History:=[]
	 XA_Load("History.xml") ; the name of the variable containing the array is returned 
	}

OnExit, SaveSettings

Loop, templates\*.txt
	templatefilelist .= A_LoopFileName "|"
templatefilelist:=Trim(templatefilelist,"|")

Sort, templatefilelist, D|

Loop, parse, templatefilelist, |
	{
 	 FileRead, a, templates\%A_LoopField%
 	 Templates[A_Index]:=a
	}

ScriptClip:=0

#Include %A_ScriptDir%\plugins\plugins.ahk

~^c::
WinGet, IconExe, ProcessPath , A
Sleep 100
ClipText:=Clipboard
Return

; show clipboard history menu
!^v::
Gosub, BuildMenuHistory
Gosub, BuildMenuPluginTemplate
Menu, ClipMenu, Show
Return

; paste as plain text
^+v::
Clipboard:=Clipboard
PasteIt()
Return

; Cycle through clipboard history
#v::
ClipCycleCounter:=1
ClipCycleFirst:=1
While GetKeyState("Lwin","D")
	{
	 ToolTip, % Chr(96+ClipCycleCounter) " : " DispToolTipText(History[ClipCycleCounter].text), %A_CaretX%, %A_CaretY%
	 Sleep 100
	 KeyWait, v ; This prevents the keyboard's auto-repeat feature from interfering.
	}
ToolTip
If (ClipCycleCounter > 0) ; If zero we've cancelled it
	{
	 ClipText:=History[ClipCycleCounter].text
	 Gosub, ClipboardHandler
	 ClipCycleCounter:=1
	}
Return
#v up::
If (ClipCycleFirst = 0)
	ClipCycleCounter++
ClipCycleFirst:=0	
Return

#c::
ClipCycleBackCounter:=1
If (ClipCycleCounter=1) or (ClipCycleCounter=0)
	Return
ClipCycleCounter--
If (ClipCycleCounter < 1)
	ClipCycleCounter:=1
While GetKeyState("Lwin","D")
	{
	 ToolTip, % Chr(96+ClipCycleCounter) " : " DispToolTipText(History[ClipCycleCounter].text), %A_CaretX%, %A_CaretY%
	 Sleep 100
	 KeyWait, c ; This prevents the keyboard's auto-repeat feature from interfering.
	}
ToolTip
Return
#c up::
If (ClipCycleBackCounter=0)
	ClipCycleCounter--
If (ClipCycleCounter < 1)
	ClipCycleCounter:=1
ClipCycleBackCounter:=0
Return

; Cancel Cycle pasting
#x up::
ToolTip
ClipCycleCounter:=0
Return

BuildMenuHistory:
Menu, ClipMenu, Delete
Menu, SubMenu1, Delete
Menu, SubMenu2, Delete
Menu, SubMenu3, Delete
Menu, SubMenu4, Delete

for k, v in History
	{
	 text:=v.text
	 icon:=v.icon
 	 key:=% "&" Chr(96+A_Index) ". " DispMenuText(SubStr(text,1,500))
	 Menu, ClipMenu, Add, %key%, MenuHandler
	 If (A_Index = 1)
	 	 Menu, ClipMenu, Icon, %key%, res\%iconC%, , 16
	 Else
		Try 	
	 		Menu, ClipMenu, Icon, %key%, % icon
	 	Catch
	 		Menu, ClipMenu, Icon, %key%, res\%iconA%, , 16
	 		 	
	 If (A_Index = 18)
		Break
	}
Return

BuildMenuPluginTemplate:

Menu, ClipMenu, Add
loop, parse, pluginlist, |
	{
	 key:=% "&" Chr(96+A_Index) ". " ; %
	 StringTrimRight,MenuText,A_LoopField,4
	 MenuText:=key RegExReplace(MenuText, "m)([A-Z]+)" , " $1")
	 Menu, Submenu1, Add, %MenuText%, SpecialMenuHandler
	 Menu, Submenu1, Icon, %MenuText%, res\%iconS%,,16
	}
Menu, ClipMenu, Add, &s. Special, :Submenu1
Menu, ClipMenu, Icon, &s. Special, res\%iconS%,,16

If (templatefilelist <> "")
	{
	 Loop, parse, templatefilelist, |
		{
		 key:=% "&" Chr(96+A_Index) ". " ; %
		 MenuText:=key SubStr(A_LoopField, InStr(A_LoopField,"_")+1)
		 StringTrimRight,MenuText,MenuText,4
		 Menu, Submenu2, Add, %MenuText%, TemplateMenuHandler
		 Menu, Submenu2, Icon, %MenuText%, res\%iconT%,,16
		}
	 Menu, Submenu2, Add, &0. Open templates folder, TemplateMenuHandler
	 Menu, Submenu2, Icon, &0. Open templates folder, res\%iconT%,,16
	}	
Else
	Menu, Submenu2, Add, "No templates", TemplateMenuHandler
Menu, ClipMenu, Add, &t. Templates, :Submenu2
Menu, ClipMenu, Icon, &t. Templates, res\%iconT%,,16
Loop 18
	Menu, Submenu3, Add, % "&" Chr(96+A_Index) ".", MenuHandler


; More history... (alt-z)

If (History.MaxIndex() > 20)
	{
	 for k, v in History
		{
		 text:=v.text
		 icon:=v.icon
	 	 If (A_Index < 19)
			Continue
	 	 If (A_Index < 45)
			 key:=% "&" Chr(96-18+A_Index) ". " DispMenuText(SubStr(text,1,500))
		 Else	 
			 key:=% "  " DispMenuText(SubStr(text,1,500))
		 Menu, SubMenu4, Add, %key%, MenuHandler
		 Try
			Menu, SubMenu4, Icon, %key%, % icon
		 Catch
 			Menu, SubMenu4, Icon, %key%, res\%iconA%, , 16
	 	 If (A_Index > 43)
			Break
		} 
	}
Else
	{
	 Menu, SubMenu4, Add, No entries ..., MenuHandler
	 Menu, SubMenu4, Icon, No entries ..., res\%iconA%, , 16
	}
		
Menu, ClipMenu, Add, &y. Yank entry, :Submenu3
Menu, ClipMenu, Icon, &y. Yank entry, res\%iconY%,,16
Menu, ClipMenu, Add, &z. More history, :Submenu4
Menu, ClipMenu, Icon, &z. More history, res\%iconZ%,,16
Menu, ClipMenu, Add
Menu, ClipMenu, Add, E&xit (Close menu), MenuHandler
Menu, ClipMenu, Icon, E&xit (Close menu), res\%iconX%,,16
Return

DispMenuText(TextIn)
	{
	 TextOut:=RegExReplace(TextIn,"m)^\s*")
	 TextOut:=RegExReplace(TextOut, "\s+", " ")
	 StringReplace,	TextOut, TextOut, &amp;amp;, &, All
	 StringReplace, TextOut, TextOut, &, &&, All	
	 If StrLen(TextOut) > 60
	 	{
		 TextOut:=SubStr(TextOut,1,40) " … " SubStr(RTrim(TextOut,".`n"),-10) Chr(171)
		} 
	 Return LTRIM(TextOut," `t")
	}

DispToolTipText(TextIn)
	{
	 TextOut:=RegExReplace(TextIn,"^\s*")
	 TextOut:=SubStr(TextOut,1,750)
	 StringReplace,TextOut,TextOut,`;,``;,All
	 Return TextOut
	}

PasteIt()
	{
	 Sleep 50
	 Send ^v
	}

; various menu handlers

MenuHandler:
If (Trim(A_ThisMenuItem) = "E&xit (Close menu)")
	Return

; Yank entry (e.g. delete from history)
If (RegExMatch(Trim(A_ThisMenuItem),"^&[a-r]\.$"))
	{
	 YankItemNo:=Asc(SubStr(Trim(A_ThisMenuItem),2,1))-96
	 History.Remove(YankItemNo)
	 Return
	}

; secondary history menu (z)
If (A_ThisMenu = "ClipMenu")
	MenuItemPos:=A_ThisMenuItemPos
else
	MenuItemPos:=A_ThisMenuItemPos+18

; debug	
; MsgBox % "A_ThisMenu-" A_ThisMenu " : A_ThisMenuItem-" A_ThisMenuItemPos " : MenuItemPost-" MenuItemPos
	
ClipText:=History[MenuItemPos].text
Gosub, ClipboardHandler
Return

SpecialMenuHandler:
SpecialFunc:=(SubStr(A_ThisMenuItem,4))
StringReplace, SpecialFunc, SpecialFunc, %A_Space%,,All
If (SpecialFunc = "AutoReplace")	
	{
	 Gosub, AutoReplace
	 Return
	}
If IsFunc(SpecialFunc)
	ClipText:=%SpecialFunc%(History[1].text)
Else
	if (SpecialFunc = "Slots")
		Gosub, ^#F12
Else
	if (SpecialFunc = "Search")	
		Gosub, ^#h
Else
	If (SpecialFunc = "DumpHistory")
		Return
Gosub, ClipboardHandler
Return

TemplateMenuHandler:
If (A_ThisMenuItem = "&0. Open templates folder")
	{
;	 Run, %A_ScriptDir%\templates\ ; use this line if you wish to use Explorer - don't forget to comment the line below
	 Run, c:\totalcmd\TOTALCMD.EXE /o %A_ScriptDir%\templates\
	 Return 
	}

ClipText:=Templates[A_ThisMenuItemPos]
Gosub, ClipboardHandler
Return

ClipBoardHandler:
ScriptClip:=1
If (ClipText <> Clipboard)
	History.Insert(1,{"text":ClipText,"icon": IconExe})
Clipboard:=ClipText
PasteIt()
ScriptClip:=0
Return

OnClipboardChange:
WinGet, IconExe, ProcessPath , A
If ((History.MaxIndex() = 0) or (History.MaxIndex() = ""))
	History.Insert(1,{"text":"Text","icon": IconExe})
if (Clipboard = "") ; avoid empty or duplicate entries
	Return 

Clipboard:=AutoReplace(Clipboard)
ClipText=%Clipboard%
History.Insert(1,{"text":ClipText,"icon": IconExe})
; check for duplicate entries
newhistory:=[]
for k, v in History
	{
	 check:=v.text
	 icon:=v.icon
	 new:=true
	 for p, q in newhistory
		{
		 if (check = q.text)
			new:=false
		}
	 if new
		newhistory.insert({"text":check,"icon":icon})
	}

History:=newhistory

ClipText:=""
newhistory:=[]
check:=""
new:=""
Return

; If the tray icon is double click we do not actually want to do anything
DoubleTrayClick: 
Return

TrayMenuHandler:

; Easy & Quick options first
If (A_ThisMenuItem = "&Reload this script")
	{
	 Reload
	 Return
	}
Else If (A_ThisMenuItem = "&Edit this script")
	{
	 Run Edit %A_ScriptName%
	 Return
	}
Else If (A_ThisMenuItem = "&Suspend Hotkeys")
	{
	 Menu, tray, ToggleCheck, &Suspend Hotkeys
	 Suspend
	 Return
	}
Else If (A_ThisMenuItem = "&Pause Script")
	{
	 Menu, tray, ToggleCheck, &Pause Script
	 Pause
	 Return
	}

; Settings menu

Else If (Trim(A_ThisMenuItem) = "Exit")
	ExitApp

Return

SaveSettings:
While (History.MaxIndex() > MaxHistory)
	History.remove(History.MaxIndex())
XA_Save("History", "History.xml") ; put variable name in quotes
XA_Save("Slots", "Slots.xml") ; put variable name in quotes
ExitApp
