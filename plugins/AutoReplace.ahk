/*

Plugin            : AutoReplace()
Version           : 1.0
CL3 version       : 1.4

*/

AutoReplaceInit:
If !IsObject(AutoReplace)
	{
	 IfExist, %A_ScriptDir%\AutoReplace.xml
		{
		 XA_Load(A_ScriptDir "\AutoReplace.xml") ; the name of the variable containing the array is returned 
		}
	 else
		{
		 AutoReplace:=[]
		}
	}
			
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
Gui, AutoReplace:Add, Button, xp+65 yp gAutoReplaceCancel w60, Cancel
Gui, AutoReplace:Add, Button, xp+65 yp gAutoReplaceSave w60, Save

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
XA_Save("AutoReplace", A_ScriptDir "\AutoReplace.xml")
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
Return

AutoReplaceUpdate(index)
	{
	 global AutoReplace
	 GuiControl, AutoReplace:,Name, % AutoReplace[index,"name"]
	 GuiControl, AutoReplace:,type, % AutoReplace[index,"type"]
	 GuiControl, AutoReplace:,find, % AutoReplace[index,"find"]
	 GuiControl, AutoReplace:,replace, % AutoReplace[index,"replace"]
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
XA_Save("AutoReplace", A_ScriptDir "\AutoReplace.xml")
Return

AutoReplaceCancel:
Gui, AutoReplace:Hide
Return

AutoReplace(text)
	{
	 global AutoReplace
	 for k, v in AutoReplace
		if (v.type = "0") or (v.type = "")
			StringReplace, text, text, % v.find, % v.replace, All
		else if (v.type = "1")	
			text:=RegExReplace(text, v.find, v.replace)
	 Return text		
	}
