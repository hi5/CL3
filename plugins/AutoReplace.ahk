/*

Plugin            : AutoReplace()
Version           : 1.2
CL3 version       : 1.4

History:
- 1.2 Added 'Try' as a fix for rare issue

*/

AutoReplaceInit:
If !IsObject(AutoReplace)
	{
	 IfExist, %A_ScriptDir%\ClipData\AutoReplace\AutoReplace.xml
		{
		 XA_Load(A_ScriptDir "\ClipData\AutoReplace\AutoReplace.xml") ; the name of the variable containing the array is returned 
		}
	 else
		{
		 AutoReplace:=[]
		}
	}

If !AutoReplace.Settings.HasKey("Active")
	AutoReplace["Settings","Active"]:=1
If !AutoReplace.Settings.HasKey("Bypass")
	AutoReplace["Settings","Bypass"]:=""

Gosub, AutoReplaceMenu
			
;Return

AutoReplaceGuiInit:
Gui, AutoReplace:Destroy
Gui, AutoReplace:Add, ListBox,w200 h170 gAutoReplaceList AltSubmit vRules, 
Gui, AutoReplace:Add, Text, xp+220 yp+5 w30, Name:
Gui, AutoReplace:Add, Edit, xp+50  yp-3 w250 vName
Gui, AutoReplace:Add, Checkbox, xp yp+30 w80 vType, RegEx?
Gui, AutoReplace:Add, Text,xp-50 yp+30 w50, Find:
Gui, AutoReplace:Add, Edit, xp+50  yp-3 w250 vFind
Gui, AutoReplace:Add, Text,xp-50 yp+30 w50, Replace:
Gui, AutoReplace:Add, Edit, xp+50  yp-3 w250 vReplace
Gui, AutoReplace:Add, Button, xp yp+40 gAutoReplaceAdd w60, New Rule
Gui, AutoReplace:Add, Button, xp+65 yp gAutoReplaceDelete w55, *Delete*
Gui, AutoReplace:Add, Button, xp+65 yp gAutoReplaceCancel w55, Cancel
Gui, AutoReplace:Add, Button, xp+65 yp gAutoReplaceSave w55, Save
Gui, AutoReplace:Add, GroupBox, x10 yp+50 w520 h50, General setting(s)
Gui, AutoReplace:Add, Text, xp+10 yp+25, Bypass (a CSV list of Exe)
Gui, AutoReplace:Add, Edit, xp+130 yp-3 w365 vBypass, 

;If !IsObject(AutoReplace)
;	Gosub, AutoReplaceInit
Gosub, AutoReplaceUpdateListbox
Return

AutoReplaceDelete:
Gui, AutoReplace:Submit, NoHide
MsgBox, 52, Delete, Delete %Name%?
IfMsgBox, No
	Return
AutoReplace.RemoveAt(Rules)
XA_Save("AutoReplace", A_ScriptDir "\ClipData\AutoReplace\AutoReplace.xml")
Gosub, AutoReplaceUpdateListbox
Return

AutoReplaceUpdateListbox:
Rules:=""
for k, v in AutoReplace
	Rules .= v.name "|"
If (Rules = "")
	Rules:="First rule"
GuiControl, AutoReplace:,Rules, % "|" Rules
AutoReplaceUpdate(1)
Return

AutoReplace:
Gosub, AutoReplaceInit
Gui, AutoReplace:Show, AutoSize Center
SendMessage, 390, 0, 0, ListBox1, A  ; LB_SETCURSEL = 390
Return

AutoReplaceUpdate(index)
	{
	 global AutoReplace
	 GuiControl, AutoReplace:,Name, % AutoReplace[index,"name"]
	 GuiControl, AutoReplace:,type, % AutoReplace[index,"type"]
	 GuiControl, AutoReplace:,find, % AutoReplace[index,"find"]
	 GuiControl, AutoReplace:,replace, % AutoReplace[index,"replace"]
	 GuiControl, AutoReplace:,Bypass, % AutoReplace.settings.Bypass
	}

AutoReplaceAdd:
GuiControl, AutoReplace:,Rules,NewRule
GuiControl, AutoReplace:,Name, 
GuiControl, AutoReplace:,type, 0
GuiControl, AutoReplace:,find, 
GuiControl, AutoReplace:,replace, 
SendMessage, 0x18b, 0, 0, ListBox1, A  ; 0x18b is LB_GETCOUNT (for a ListBox).
SendMessage, 390, (Errorlevel-1), 0, ListBox1, A  ; LB_SETCURSEL = 390
ControlFocus, Edit1, A
Return

AutoReplaceList:
Gui, AutoReplace:Submit, NoHide
AutoReplaceUpdate(Rules)
Return

AutoReplaceSave:
Gui, AutoReplace:Submit, Hide
If (Rules = "")
	Rules:=1
If (Find = "")
	Return
name:=name ? name : "Unnamed rule"	
AutoReplace[Rules,"name"]:=name
AutoReplace[Rules,"type"]:=type
AutoReplace[Rules,"find"]:=find
AutoReplace[Rules,"replace"]:=replace
AutoReplace.Settings.Bypass:=Bypass
XA_Save("AutoReplace", A_ScriptDir "\ClipData\AutoReplace\AutoReplace.xml")
Return

AutoReplaceCancel:
Gui, AutoReplace:Hide
Return

AutoReplace()
	{
	 global AutoReplace,IconExe
	 if !AutoReplace.Settings.Active ; bypass AutoReplace
	 	Return
	 if RegExMatch(IconExe, "im)\\(" StrReplace(AutoReplace.Settings.Bypass,",","|") ")$") ; bypass AutoReplace
	 	Return
	 ClipStore:=ClipboardAll ; store all formats
	 ClipStoreText:=Clipboard ; store text

	 OnClipboardChange("FuncOnClipboardChange", 0)

	 for k, v in AutoReplace
	 {
		if (v.type = "0") or (v.type = "")
			{
			 Try
			 	{
				 Clipboard:=StrReplace(Clipboard, v.find, v.replace)
			 	}
			}
		else if (v.type = "1")	
			{
			 Try
			 	{
				 Clipboard:=RegExReplace(Clipboard, v.find, v.replace)
			 	}
			}
	 }
	 if (Clipboard = ClipStoreText) ; if we haven't actually modified the text make sure we restore all formats
	 	Clipboard:=ClipStore
	 ClipStore:=""	

	 OnClipboardChange("FuncOnClipboardChange", 1)

	}

AutoReplaceMenu:
If AutoReplace.Settings.Active
	Menu, tray, Check, &AutoReplace Active
Else
	Menu, tray, UnCheck, &AutoReplace Active
Return	