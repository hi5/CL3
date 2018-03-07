/*

Script      : CL3 ( = CLCL CLone ) - AutoHotkey 1.1+ (Ansi and Unicode)
Version     : 1.92
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
  v1.5: ClipChain cycle through a predefined clipboard history
  v1.6: Compact (reduce size of History) and delete from search search results
  v1.7: FIFO Paste back in the order in which the entries were added to the clipboard history
  v1.8: Edit entries in History (via search). Cycle through plugins
  v1.9: Folder structure for Templates\

See readme.md for more info and documentation on plugins and templates.

*/

; General script settings
#SingleInstance, Force
SetBatchlines, -1
SendMode, Input
SetWorkingDir, %A_ScriptDir%
AutoTrim, off
MaxHistory:=150
name:="CL3 "
version:="v1.92"
ScriptClip:=1
CycleFormat:=0
Templates:={}
Global CyclePlugins ; v1.72+
Error:=0
CoordMode, Menu, Screen
ListLines, Off
PasteTime:=A_TickCount

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
Menu, tray, Add, %name% %version%,    DoubleTrayClick
Menu, tray, Default, %name% %version%
Menu, tray, Add, 
Menu, tray, Add, &AutoReplace Active, TrayMenuHandler
Menu, tray, Add, &FIFO Active,        TrayMenuHandler
Menu, tray, Add, 
Menu, tray, Add, &Reload this script, TrayMenuHandler
Menu, tray, Add, &Edit this script,   TrayMenuHandler
Menu, tray, Add, 
Menu, tray, Add, &Suspend Hotkeys,    TrayMenuHandler
Menu, tray, Add, &Pause Script,       TrayMenuHandler
Menu, tray, Add, 
Menu, tray, Add, Exit,                SaveSettings

Menu, ClipMenu, Add, TempText, MenuHandler
Menu, SubMenu1, Add, TempText, MenuHandler
Menu, SubMenu2, Add, TempText, MenuHandler
Menu, SubMenu3, Add, TempText, MenuHandler
Menu, SubMenu4, Add, TempText, MenuHandler

; load clipboard history and templates
IfNotExist, %A_ScriptDir%\ClipData\History\History.xml
	Error:=1

Try
	{
	 XA_Load( A_ScriptDir "\ClipData\History\History.xml") ; the name of the variable containing the array is returned 
	}
Catch
	{
	 Error:=1
	}

If (Error = 1)
	{
	 FileCopy, res\history.bak.txt, %A_ScriptDir%\ClipData\History\History.xml, 1
	 History:=[]
	 XA_Load(A_ScriptDir "\ClipData\History\History.xml") ; the name of the variable containing the array is returned 
	}

Settings()

OnExit, SaveSettings

; get templates in root folder first
Loop, templates\*.txt
	templatefilelist .= A_LoopFileName "|"
templatefilelist:=Trim(templatefilelist,"|")
Sort, templatefilelist, D|

Loop, parse, templatefilelist, |
	{
	 FileRead, a, templates\%A_LoopField%
	 Templates["submenu2",A_Index]:=a
	 a:=""
	}

; now check for folders for possible sub-submenus
Loop, Files, templates\*.*, D
	templatesfolderlist .= A_LoopFileName "|"
templatesfolderlist:=Trim(templatesfolderlist,"|")
Sort, templatesfolderlist, D|
StringUpper, templatesfolderlist, templatesfolderlist

ScriptClip:=0

#Include %A_ScriptDir%\plugins\plugins.ahk

~^c::
WinGet, IconExe, ProcessPath , A
Sleep 100
ClipText:=Clipboard
Return

; show clipboard history menu
!^v::
Gosub, FifoInit
BuildMenuFromFifo:
Gosub, BuildMenuHistory
Gosub, BuildMenuPluginTemplate
WinGetPos, MenuX, MenuY, , , A
MenuX+=A_CaretX
MenuX+=20
MenuY+=A_CaretY
MenuY+=10
If (A_CaretX <> "")
	Menu, ClipMenu, Show, %MenuX%, %MenuY%
Else
 {
;	TrayTip, TrayMenu, CL3Coords2, 2 ; debug
	Menu, ClipMenu, Show
 }
Return

; 1x paste as plain text
; 2x paste unwrapped
^+v::
If (Clipboard = "") ; probably image format in Clipboard
	Clipboard:=History[1].text
; 1x paste as plain text
If (A_TimeSincePriorHotkey<400) and (A_TimeSincePriorHotkey<>-1)
	{
	 Clipboard:=PasteUnwrapped(Clipboard)
	}
; 2x paste unwrapped
else
	{
	 Clipboard:=Trim(Clipboard,"`n`r`t ")
	}
PasteIt()
Return

^v:: ; v1.91
PasteIt()
Return

; Cycle through clipboard history
#v::
PreviousClipCycleCounter:=0 ; 13/10/2017 test
ClipCycleCounter:=1
ClipCycleFirst:=1
While GetKeyState("Lwin","D")
	{
	 If !(PreviousClipCycleCounter = ClipCycleCounter)
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
PreviousClipCycleCounter:=ClipCycleCounter
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
	 If !(PreviousClipCycleCounter = ClipCycleCounter)
		ToolTip, % Chr(96+ClipCycleCounter) " : " DispToolTipText(History[ClipCycleCounter].text), %A_CaretX%, %A_CaretY%
	 Sleep 100
	 KeyWait, c ; This prevents the keyboard's auto-repeat feature from interfering.
	}
ToolTip
Return
#c up::
PreviousClipCycleCounter:=""
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

; use #f to cycle through formats (defined in settings.ini / [plugins])
; #If ClipCycleCounter
#f::
CycleFormat:=0
If (ClipCycleCounter = 0) or (ClipCycleCounter = "")
	ClipCycleCounter:=1
While GetKeyState("Lwin","D")
	{
	 ToolTip, % "Plugin: " ((CyclePlugins.HasKey(CycleFormat) = "0") ? "[none]" : CyclePlugins[CycleFormat]) "`n——————————————————————`n" DispToolTipText(History[ClipCycleCounter].text,CycleFormat), %A_CaretX%, %A_CaretY%
	 ; ToolTip, % CycleFormat, %A_CaretX%, %A_CaretY%
	 Sleep 100
	 KeyWait, f ; This prevents the keyboard's auto-repeat feature from interfering.
	}
ToolTip
If (ClipCycleCounter > 0) ; If zero we've cancelled it
	{
	 ClipText:=DispToolTipText(History[ClipCycleCounter].text,CycleFormat)
	 Gosub, ClipboardHandler
	 ClipCycleCounter:=0
	}
Return

#f up::
if (CycleFormat > CyclePlugins.MaxIndex())
	CycleFormat:=0
CycleFormat++
Sleep 100
Return	

BuildMenuHistory:
Menu, ClipMenu, Delete
Try
	Menu, SubMenu1, Delete
Try
	Menu, SubMenu2, Delete
Try
	Menu, SubMenu3, Delete
Try
	Menu, SubMenu4, Delete

for k, v in History
	{
	 text:=v.text
	 icon:=v.icon
	 if (icon = "")
		icon:="res\" iconA
 	 key:=% "&" Chr(96+A_Index) ". " DispMenuText(SubStr(text,1,500))
	 Menu, ClipMenu, Add, %key%, MenuHandler
	 if (k = 1)
		Menu, ClipMenu, Default, %key%
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

If !FIFOACTIVE
	{
	 pluginlist:=pluginlistClip "|#" MyPluginlistFunc "|#" pluginlistFunc
	 loop, parse, pluginlist, |
		{
		 if (SubStr(A_LoopField,1,1) = "#")
			{
			 If (StrLen(A_LoopField) = 1)
				continue
			 Menu, Submenu1, Add
			}
		 key:=% "&" Chr(96+A_Index) ". " ; %
		 StringTrimRight,MenuText,A_LoopField,4
		 MenuText:=Trim(MenuText,"#")
		 MenuText:=key RegExReplace(MenuText, "m)([A-Z]+)" , " $1")
		 Menu, Submenu1, Add, %MenuText%, SpecialMenuHandler
		 Menu, Submenu1, Icon, %MenuText%, res\%iconS%,,16
		}
Menu, ClipMenu, Add, &s. Special, :Submenu1
Menu, ClipMenu, Icon, &s. Special, res\%iconS%,,16

If (templatefilelist <> "")
	{
	 Loop, Parse, templatefilelist, |
		{
		 key:=% "&" Chr(96+A_Index) ". " ; %
		 MenuText:=key SubStr(A_LoopField, InStr(A_LoopField,"_")+1)
		 StringTrimRight,MenuText,MenuText,4
		 Menu, Submenu2, Add, %MenuText%, TemplateMenuHandler
		 Menu, Submenu2, Icon, %MenuText%, res\%iconT%,,16
		}
	 Menu, Submenu2, Add, &0. Open templates folder, TemplateMenuHandler
	 Menu, Submenu2, Icon, &0. Open templates folder, res\%iconT%,,16

	If (templatesfolderlist <> "")
		{
		 Loop, Parse, templatesfolderlist, |
		 {

			templatefolder:=A_LoopField
			Loop, files, templates\%A_LoopField%\*.txt
				{
				 templatefolderFiles .= A_LoopFileName "|"
				 Sort, templatefolderFiles, D|
				}
			templatefolderFiles:=Trim(templatefolderFiles,"|")
			Loop, parse, templatefolderFiles, |
				{
				 FileRead, a, templates\%templatefolder%\%A_LoopField%
				 Templates[templatefolder,A_Index]:=a
				 key:=% "&" Chr(96+A_Index) ". " ; %
				 MenuText:=key SubStr(A_LoopField, InStr(A_LoopField,"_")+1)
				 Menu, %templatefolder%, Add, %MenuText%, TemplateMenuHandler
				 Menu, %templatefolder%, Icon, %MenuText%, res\%iconT%,,16
				 a:=""
				}
			templatefolderFiles:=""
		 }

		 Loop, parse, templatesfolderlist, |
			{
			 Menu, SubMenu2, Add, &%A_LoopField%, :%A_LoopField%
			 try
				Menu, SubMenu2, Icon, &%A_LoopField%, templates\%A_LoopField%\favicon.ico,,16
			 catch
				Menu, SubMenu2, Icon, &%A_LoopField%, res\%iconT%,,16
			}
		}
	}
Else
	Menu, Submenu2, Add, "No templates", TemplateMenuHandler
Menu, ClipMenu, Add, &t. Templates, :Submenu2
Menu, ClipMenu, Icon, &t. Templates, res\%iconT%,,16
Loop 18
	Menu, Submenu3, Add, % "&" Chr(96+A_Index) ".", MenuHandler
}

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

If !FIFOACTIVE
	{
	 Menu, ClipMenu, Add, &y. Yank entry, :Submenu3
	 Menu, ClipMenu, Icon, &y. Yank entry, res\%iconY%,,16
	}
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
		 TextOut:=SubStr(TextOut,1,40) " " Chr(8230) " " SubStr(RTrim(TextOut,".`n"),-10) Chr(171) ; 8230 ...
		} 
	 Return LTRIM(TextOut," `t")
	}

DispToolTipText(TextIn,Format=0)
	{
	 TextOut:=RegExReplace(TextIn,"^\s*")
	 TextOut:=SubStr(TextOut,1,750)
	 StringReplace,TextOut,TextOut,`;,``;,All
	 FormatFunc:=StrReplace(CyclePlugins[Format]," ")
	 If IsFunc(FormatFunc)
		TextOut:=%FormatFunc%(TextOut)
	 Return TextOut
	}

PasteIt()
	{
	 global StartTime,PasteTime
	 StartTime:=A_TickCount
	 If ((StartTime - PasteTime) < 75) ; to prevent double paste after using #f/#v in combination
		Return
	 #Include *i %A_ScriptDir%\plugins\PastePrivateRules.ahk
	 Sleep 50
	 Send ^v
	 PasteTime := A_TickCount
	}


; various menu handlers

MenuHandler:
If (Trim(A_ThisMenuItem) = "E&xit (Close menu)")
	{
	 If !FIFOACTIVE:=0
		Return
	 FIFOACTIVE:=0
	 Gosub, FifoInit
	 Gosub, FifoActiveMenu
	 Return
	}

; Yank entry (e.g. delete from history)
If (RegExMatch(Trim(A_ThisMenuItem),"^&[a-r]\.$"))
	{
	 YankItemNo:=Asc(SubStr(Trim(A_ThisMenuItem),2,1))-96
	 History.Remove(YankItemNo)
	 If FIFOACTIVE
		{
		 Gosub, FifoInit
		 Gosub, FifoActiveMenu
		}
	 Return
	}

; secondary history menu (z)
If (A_ThisMenu = "ClipMenu")
	MenuItemPos:=A_ThisMenuItemPos
else
	MenuItemPos:=A_ThisMenuItemPos+18

; debug	
; MsgBox % "A_ThisMenu-" A_ThisMenu " : A_ThisMenuItem-" A_ThisMenuItemPos " : MenuItemPost-" MenuItemPos

If FIFOACTIVE
	{
	 FIFOID:=MenuItemPos
	 Gosub, FifoActiveMenu
	 TrayTip, FIFO, FIFO Paste Mode Activated, 2, 1
	 Return
	}

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
	if (SpecialFunc = "ClipChain")
		Gosub, ^#F11
Else
	If (SpecialFunc = "DumpHistory")
		Return
Else
	If (SpecialFunc = "Compact")
		Gosub, Compact
Else
	If (SpecialFunc = "Fifo")
		Gosub, ^#F10
Gosub, ClipboardHandler
Return

TemplateMenuHandler:
If (A_ThisMenuItem = "&0. Open templates folder")
	{
	 IfWinExist, ahk_exe TOTALCMD.EXE
		Run, c:\totalcmd\TOTALCMD.EXE /O /T %A_ScriptDir%\templates\
	 else	
		Run, %A_ScriptDir%\templates\ 
	 Return 
	}

ClipText:=Templates[A_ThisMenu,A_ThisMenuItemPos]
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
; The built-in variable A_EventInfo contains:
; 0 if the clipboard is now empty;
; 1 if it contains something that can be expressed as text (this includes files copied from an Explorer window);
; 2 if it contains something entirely non-text such as a picture.
If (A_EventInfo <> 1)
	Return

;If (ScriptClip = 1) ; 
;	Return
WinGet, IconExe, ProcessPath , A
If ((History.MaxIndex() = 0) or (History.MaxIndex() = ""))
	History.Insert(1,{"text":"Text","icon": IconExe})

If !WinExist("CL3ClipChain ahk_class AutoHotkeyGUI")
	ScriptClipClipChain:=0

if (Clipboard = "") or (ScriptClipClipChain = 1) ; avoid empty entries or changes made by script which you don't want to keep
	Return 

AutoReplace()
ClipText=%Clipboard%
;MsgBox % ClipText
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
			{
			 new:=false
			}
		}
	 if new
		newhistory.push({"text":check,"icon":icon})
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
Else If (A_ThisMenuItem = "&AutoReplace Active")
	{
	 If AutoReplace.Settings.Active
		AutoReplace.Settings.Active:=0
	 else
		AutoReplace.Settings.Active:=1
	 XA_Save("AutoReplace", A_ScriptDir "\ClipData\AutoReplace\AutoReplace.xml")
	 Gosub, AutoReplaceMenu
	}
Else If (A_ThisMenuItem = "&FIFO Active")
	{
	 Gosub, FifoActiveMenu
	}


; Settings menu

Else If (Trim(A_ThisMenuItem) = "Exit")
	ExitApp

Return

SaveSettings:
While (History.MaxIndex() > MaxHistory)
	History.remove(History.MaxIndex())
XA_Save("History", A_ScriptDir "\ClipData\History\History.xml") ; put variable name in quotes
XA_Save("Slots", A_ScriptDir "\ClipData\Slots\Slots.xml") ; put variable name in quotes
XA_Save("ClipChainData", A_ScriptDir "\ClipData\ClipChain\ClipChain.xml") ; put variable name in quotes
ExitApp
