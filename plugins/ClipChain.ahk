/*

Plugin            : ClipChain
Purpose           : Cycle through a predefined clipboard history on each paste
Version           : 1.8
CL3 version       : 1.5

History:
- 1.8 Preview ToolTip on Mouse Hover
- 1.71 fix cancelled Load from Clipboard (Set Delim)
- 1.7 enter (multiple) delimiter(s) to split elements from clipboard;
      define send key(s) after paste (AutoHotkey notation) e.g. {tab};
      define Trim options
- 1.6 Attempt to prevent XMLRoot error - https://github.com/hi5/CL3/issues/15
- 1.5.1 Fix for hotkey, using much more reliable #If
- 1.5 Clipchain: you can now define a hotkey (via settings) to "progress to next item" - this will allow you to keep ^v for normal copy/paste actions - see Clipchain HK (settings)
- 1.4 Added QEDL() for edit and insert (not public)
- 1.3 Added DoubleClick to paste and progress ClipChain
- 1.2 Fixed LV_Modify empty parameters because of AutoHotkey v1.1.23.03 update
- 1.1 Added minor fix for "non-empty" empty lines?

*/

ClipChainInit:
IniRead, ClipChainX          , %ClipDataFolder%ClipChain\ClipChain.ini, Settings, ClipChainX, 100
IniRead, ClipChainY          , %ClipDataFolder%ClipChain\ClipChain.ini, Settings, ClipChainY, 100
IniRead, ClipChainNoHistory  , %ClipDataFolder%ClipChain\ClipChain.ini, Settings, ClipChainNoHistory , 0
IniRead, ClipChainTrans      , %ClipDataFolder%ClipChain\ClipChain.ini, Settings, ClipChainTrans     , 0
IniRead, ClipChainKey        , %ClipDataFolder%ClipChain\ClipChain.ini, Settings, ClipChainKey
IniRead, ClipChainSend       , %ClipDataFolder%ClipChain\ClipChain.ini, Settings, ClipChainSend
IniRead, ClipChainPause      , %ClipDataFolder%ClipChain\ClipChain.ini, Settings, ClipChainPause     , 0
IniRead, ClipChainTrim       , %ClipDataFolder%ClipChain\ClipChain.ini, Settings, ClipChainTrim      , 0
IniRead, ClipChainTrimSet    , %ClipDataFolder%ClipChain\ClipChain.ini, Settings, ClipChainTrimSet
IniRead, ClipChainPreview    , %ClipDataFolder%ClipChain\ClipChain.ini, Settings, ClipChainPreview   , 1

If (ClipChainX = "") or (ClipChainX = "ERROR")
	ClipChainX:=100
If (ClipChainY = "") or (ClipChainY = "ERROR")
	ClipChainY:=100
If (ClipChainKey = "") or (ClipChainKey = "ERROR") or (ClipChainKey = 0)
	ClipChainKey:="[press to set]"
If (ClipChainTrimSet = "") or (ClipChainTrimSet = "ERROR") or (ClipChainTrimSet = 0)
	ClipChainTrimSet:="[press to set]"
else
	Gosub, SetTrim

If !IsObject(ClipChainData)
	{
	 IfExist, %ClipDataFolder%ClipChain\ClipChain.xml
		{
		 If (XA_Load(ClipDataFolder "ClipChain\ClipChain.xml") = 1) ; the name of the variable containing the array is returned OR the value 1 in case of error
			{
			 MsgBox, 16, ClipChain, ClipChain.xml seems to be corrupt, starting new empty chain.
			 FileDelete, %ClipDataFolder%ClipChain\ClipChain.xml
			 ClipChain:=[]
			}
		}
	 else
		{
		 ClipChain:=[]
		}
	}

ClipChainIndex:=1
LVM_SUBITEMHITTEST := 4096 + 57

;ClipboardPrivateRulesFunc:="ClipboardPrivateRules"

Menu, ClipChainMenu, Add
Menu, ClipChainMenu, Delete

Menu, ClipChainMenu, Add, Load from Clipboard (Default), ClipChainLoad
Menu, ClipChainMenu, Add, Load from Clipboard (Set Delim), ClipChainLoadDelim
Menu, ClipChainMenu, Add
Menu, ClipChainMenu, Add, Load from File, ClipChainLoadFile
Menu, ClipChainMenu, Add, Save to File, ClipChainSaveFile
Menu, ClipChainMenu, Add
Menu, ClipChainMenu, Add, Clear ClipChain, ClipChainClear

Gui, ClipChain:Default
Gui, ClipChain:+Border +ToolWindow +AlwaysOnTop +E0x08000000 ; +E0x08000000 = WS_EX_NOACTIVATE ; ontop and don't activate
Gui, ClipChain:Font, % dpi("s8")
Gui, ClipChain:Add, Listview, % dpi("x0 y0 w185 h350 NoSortHdr grid vLVCGIndex gClipChainClicked hwndHLV"),?|ClipChain|IDX
LV_ModifyCol(1,dpi()*25)
LV_ModifyCol(2,dpi()*160)
LV_ModifyCol(3,*0)
;LV_ModifyCol(2,100) ; debug
;LV_ModifyCol(3,30)  ; debug
Gosub, ClipChainListview

Gui, ClipChain:font,% dpi("s8")
Gui, ClipChain:Add, GroupBox, % dpi("x2 yp+355 w181 h50 vGbox1"), Chain(s)
Gui, ClipChain:Add, Button, % dpi("xp+8  yp+18 w26 h26   gClipChainMoveUp   vButton1"), % Chr(0x25B2) ; ▲
Gui, ClipChain:Add, Button, % dpi("xp+28 yp    w26 h26   gClipChainMoveDown vButton2"), % Chr(0x25BC) ; ▼
Gui, ClipChain:Add, Button, % dpi("xp+28 yp    w26 h26   gClipChainInsert   vButton3"), Ins
Gui, ClipChain:font,% dpi("s11") ; " Wingdings"
Gui, ClipChain:Add, Button, % dpi("xp+28 yp    w26 h26   gClipChainEdit     vButton4"), % Chr(0x270E) ; ✎ ; % Chr(33) ; Edit (pencil)
Gui, ClipChain:font
Gui, ClipChain:font, % dpi("s12 bold")
Gui, ClipChain:Add, Button, % dpi("xp+28 yp    w26 h26   gClipChainDel      vButton5"), % Chr(0x1f5d1) ; trashcan ; X ; Del (X)
Gui, ClipChain:font
Gui, ClipChain:font,% dpi("s11") ; " Wingdings "
Gui, ClipChain:Add, Button, % dpi("xp+28 yp    w26 h26   gClipChainMenu     vButton6"), % Chr(0x1F4C2) ; open folder 📂; % Chr(49)
Gui, ClipChain:font
Gui, ClipChain:font,% dpi("s8")
Gui, ClipChain:Add, GroupBox, % dpi("x2 yp+40 w181 h170 vGbox2"), Options
Gui, ClipChain:Add, Checkbox, % dpi("xp+10 yp+18  w75 h24 vClipChainNoHistory gClipChainCheckboxes"), No History
Gui, ClipChain:Add, Checkbox, % dpi("xp+80 yp     w85 h24 vClipChainTrans     gClipChainCheckboxes"), Transparent
Gui, ClipChain:Add, Checkbox, % dpi("xp-80 yp+30  w75 h24 vClipChainSend      gClipChainCheckboxes"), Send after
Gui, ClipChain:Add, Button  , % dpi("xp+80 yp     w85 h24 vClipChainKey       gClipChainKeyUpdate" ), %ClipChainKey%
Gui, ClipChain:Add, Checkbox, % dpi("xp-80 yp+30  w75 h24 vClipChainTrim      gClipChainCheckboxes"), Trim
Gui, ClipChain:Add, Button  , % dpi("xp+80 yp     w85 h24 vClipChainTrimSet   gClipChainTrimUpdate"), %ClipChainTrimSet%

Gui, ClipChain:Add, Checkbox, % dpi("xp-80 yp+30  w75 h24 vClipChainPause     gClipChainCheckboxes"), Pause
Gui, ClipChain:Add, Button  , % dpi("xp+80 yp     w85 h24 vClipChainGuiClose  gClipChainGuiClose"  ), Close ClipChain
Gui, ClipChain:Add, Checkbox, % dpi("xp-80 yp+30 w150 h24 vClipChainPreview   gClipChainCheckboxes"), Show preview TT on Hover

GuiControl, ClipChain:, ClipChainNoHistory  , %ClipChainNoHistory%
GuiControl, ClipChain:, ClipChainTrans      , %ClipChainTrans%
GuiControl, ClipChain:, ClipChainKey        , %ClipChainKey%
GuiControl, ClipChain:, ClipChainTrim       , %ClipChainTrim%
GuiControl, ClipChain:, ClipChainPause      , %ClipChainPause%
GuiControl, ClipChain:, ClipChainPreview    , %ClipChainPreview%

Gosub, ClipChainCheckboxes
ClipChainLvHandle := New LV_Rows(HLV)

Return

ClipChainTrimUpdate:
InputBox, ClipChainTrimSet, ClipChain Trim characters, Set Trim characters Delimiter(s) (\n`,\r`,\t`,\s`)`nTrims Left and Right, , 300, 140, , , , , %ClipChainTrimSet%
If ErrorLevel
	Return
If (ClipChainTrimSet = "")
	{
	 ClipChainTrimSet := "[press to set]"
	 GuiControl, ClipChain:, ClipChainTrimSet       , %ClipChainTrimSet%
	 Return
	}
GuiControl, ClipChain:, ClipChainTrimSet      , %ClipChainTrimSet%
SetTrim:
TrimSet:=ClipChainTrimSet
TrimSet:=StrReplace(TrimSet,"\n","`n")
TrimSet:=StrReplace(TrimSet,"\r","`r")
TrimSet:=StrReplace(TrimSet,"\t","`t")
TrimSet:=StrReplace(TrimSet,"\s"," ")
Return



ClipChainKeyUpdate:
InputBox, ClipChainKey, ClipChain Send after Paste, Send key(s) after paste (AutoHotkey notation), , 300, 130, , , , , %ClipChainKey%
If ErrorLevel
	Return
If (ClipChainKey = "")
	{
	 ClipChainKey := "[press to set]"
	 GuiControl, ClipChain:, ClipChainKey      , %ClipChainKey%
	 Return
	}
GuiControl, ClipChain:, ClipChainKey      , %ClipChainKey%
Return

#IfWinExist CL3ClipChain ahk_class AutoHotkeyGUI
~LButton::
If ClipChainPause
	Return
If (A_TimeSincePriorHotkey<400) and (A_TimeSincePriorHotkey<>-1)
	{ ; check if you double clicked on the listview if so move away focus from listview otherwise we couldn't set the new active item by double clicking in the LV
	 ControlGetFocus, CL3ClipChainListview, CL3ClipChain ahk_class AutoHotkeyGUI
	 If (CL3ClipChainListview = "SysListView321")
	 	{
	 	 ControlFocus, Button12, CL3ClipChain ahk_class AutoHotkeyGUI ; Button12 is Close ClipChain
	 	 Return
	 	}
	 Gosub, ClipChainPasteDoubleClick
	}
Return
#IfWinActive

#If ClipChainActive()

;$^v::
ClipChainPasteDoubleClick:
Gui, ClipChain:Default
Gui, ClipChain:Submit, NoHide
If ClipChainPause
	Return
If (ClipChainIndex > ClipChainData.MaxIndex())
	{
	 ClipChainIndex:=1
	}
If ClipChainNoHistory
	OnClipboardChange("FuncOnClipboardChange", 0)
;If IsFunc(ClipboardPrivateRulesFunc)
;	%ClipboardPrivateRulesFunc%("ClipChain")
Clipboard:=ClipChainData[ClipChainIndex]
If ClipChainTrim
{
	Clipboard:=Trim(Clipboard,TrimSet)
msgbox hi %TrimSet%
}
PasteIt()
Sleep 100
Clipboard:=History[1].text
If ClipChainNoHistory
	OnClipboardChange("FuncOnClipboardChange", 1)
stats.clipchain++
ClipChainIndex++
If ClipChainSend and (ClipChainKey <> "[press to set]")
	Send % ClipChainKey
Gosub, ClipChainUpdateIndicator
Return
#If

;^#F11::
hk_clipchain:
If !WinExist("CL3ClipChain ahk_class AutoHotkeyGUI")
	{
	 ; https://www.autohotkey.com/boards/viewtopic.php?t=77789
	 OnMessage( WM_MOUSEMOVE := 0x200, "WM_MOUSEMOVE" ) ; monitor mouse moving over our windowOnMessage( WM_MOUSEMOVE := 0x200, "WM_MOUSEMOVE" ) ; monitor mouse moving over our window
	 Gui, ClipChain:Show, % dpi("w185 NA x") ClipChainX " y" ClipChainY, CL3ClipChain
	}
else
 	{
	 Gosub, ClipChainSaveWindowPosition
	 Gui, ClipChain:Hide
 	}
Gosub, ClipChainCheckboxes
Return

ClipChainMenu:
Menu, ClipChainMenu, Show
Return

ClipChainSaveFile:
SaveAsName:=""
Gui, ClipChain:Submit, Hide
InputBox, SaveAsName, Name for XML, Save Clipchain as
If (SaveAsName = "")
	{
	 MsgBox, Enter filename!`nSlots not saved.
	 Gui, ClipChain:Show
	 Return
	}
StringReplace, SaveAsName, SaveAsName, .xml,,All
XA_Save("ClipChainData", ClipDataFolder "ClipChain\" SaveAsName ".xml") ; put variable name in quotes
Return

ClipChainClear:
Gui, ClipChain:Default
LV_Delete()
ClipChainDataNew:=[]
Return

ClipChainSet:
ClipChainNewOrder:=""
ClipChainDataNew:=[]
ClipChainIns:=""
ClipChainDataIndex:=""
Loop, % LV_GetCount()
	{
	 LV_GetText(ClipChainDataIndex, A_Index, 3)
	 ClipChainNewOrder .= ClipChainDataIndex ","
	}
ClipChainNewOrder:=RTrim(ClipChainNewOrder,",")
Loop, parse, ClipChainNewOrder, CSV
	ClipChainDataNew.push(ClipChainData[A_LoopField])
ClipChainData:=[]
ClipChainData:=ClipChainDataNew
ClipChainDataNew:=[]
Gosub, ClipChainUpdateIDX
Gosub, ClipChainUpdateIndicator
Return

ClipChainUpdateIDX:
Loop, % LV_GetCount()
	LV_Modify(A_Index,"Col3",A_Index)
Return

ClipChainEdit: ; falls through to Insert
ClipChainGuiTitle:="CL3ClipChain Edit text"
ClipChainInsEdit:=1

ClipChainInsert:
If (ClipChainGuiTitle = "")
	ClipChainGuiTitle:="CL3ClipChain Insert text"
ClipChainInsertCounter:=1
ClipChainPauseStore:=ClipChainPause
ClipChainPause:=1
GuiControl, ClipChain:, ClipChainPause      , %ClipChainPause%

ClipChainIns:=""
ClipChainDataIndex:=""
Gui, ClipChain:Default
Gui, ClipChain:Submit, NoHide
LVCGIndex := LV_GetNext()
If (LVCGIndex = 0)
	LVCGIndex = 1
LV_GetText(ClipChainDataIndex, LVCGIndex, 3)
If (ClipChainDataIndex = "")
	{
	 ClipChainDataIndex:=1
	 ClipChainInsertCounter:=0
	}
If (ClipChainInsEdit = 1)
	ClipChainIns:=ClipChainData[ClipChainDataIndex]
Gosub, ClipChainInsertGui
If (ClipChainIns = "")
	{
	 ClipChainPause:=ClipChainPauseStore
	 ClipChainPauseStore:=""
	 GuiControl, ClipChain:, ClipChainPause      , %ClipChainPause%
	 Return
	}
If (ClipChainInsEdit = 1)
	{
	 ClipChainData[ClipChainDataIndex]:=ClipChainIns
	 If (ClipChainInsertCounter = 0)
	 	LV_Add(1,,,,1)
	 LV_Modify(ClipChainDataIndex,"Col2",ClipChainHelper(ClipChainIns))
	}
else
	{
	 ClipChainData.InsertAt(ClipChainDataIndex+ClipChainInsertCounter,ClipChainIns)
	 LV_Insert(ClipChainDataIndex+1, , , ClipChainHelper(ClipChainIns))
	}
Gosub, ClipChainUpdateIDX
ClipChainInsEdit:=0

ClipChainPause:=ClipChainPauseStore
ClipChainPauseStore:=""
GuiControl, ClipChain:, ClipChainPause      , %ClipChainPause%
ClipChainGuiTitle:=""
Gosub, ClipChainSet
XMLSave("ClipChainData")
Return

ClipChainInsertGui:
ClipChainInsertActive:=0

; not public
;@Ahk2Exe-IgnoreBegin
#include *i %A_ScriptDir%\plugins\MyQEDLG-ClipChain.ahk
;@Ahk2Exe-IgnoreEnd

Gui, ClipChainInsertGui:Destroy
Gui, ClipChainInsertGui:Add, Text, x5 y5, Insert text into chain after %ClipChainDataIndex% item:
Gui, ClipChainInsertGui:Add, Edit, xp yp+20 w500 h300 vClipChainIns, %ClipChainIns%
Gui, ClipChainInsertGui:Add, Button, gClipChainInsertGuiOK w100, OK
Gui, ClipChainInsertGui:Add, Button, xp+120 gClipChainInsertGuiCancel w100, Cancel
Gui, ClipChainInsertGui:Show, , %ClipChainGuiTitle%
	While (ClipChainInsertActive = 0)
		{
		 Sleep 20
		}
Return

ClipChainDel:
XMLSave("ClipChainData","-" A_Now)
ClipChainDataIndex:=""
Gui, ClipChain:Default
Gui, ClipChain:Submit, NoHide
LVCGIndex := LV_GetNext()
If (LVCGIndex = 0)
	LVCGIndex = 1
LV_GetText(ClipChainDataIndex, LVCGIndex, 3)
for k, v in ClipChainData
	if (v = ClipChainData[ClipChainDataIndex])
		LV_Delete(A_Index)
If (ClipChainData.Length() <> 0)
	ClipChainData.RemoveAt(ClipChainDataIndex)
Gosub, ClipChainUpdateIDX
Gosub, ClipChainSet
XMLSave("ClipChainData")
Return

ClipChainCheckboxes:
Gui, ClipChain:Default
Gui, ClipChain:Submit, NoHide

; no longer used v1.95
;If ClipChainNoHistory
;	ScriptClipClipChain:=1
;else If !ClipChainNoHistory
;	ScriptClipClipChain:=0

If ClipChainTrans
	WinSet, Transparent, 200, CL3ClipChain ahk_class AutoHotkeyGUI
else If !ClipChainTrans
	WinSet, Transparent, 255, CL3ClipChain ahk_class AutoHotkeyGUI

Return

ClipChainClicked:
Gui, ClipChain:Default
ClipChainIndex:=A_EventInfo
Gosub, ClipChainUpdateIndicator
Return

ClipChainLoadDelim:
CCDelim:=""
InputBox, CCDelim, ClipChain Delimiter, Set Delimiter(s) CSV (\n`,\r`,\t`,\s`,\c)`nUse \c for comma, , 300, 140, , , , , \n
If ErrorLevel or  or (CCDelim = "")
	 Return

CCDelim:=StrReplace(CCDelim,"\n","`n")
CCDelim:=StrReplace(CCDelim,"\r","`r")
CCDelim:=StrReplace(CCDelim,"\t","`t")
CCDelim:=StrReplace(CCDelim,"\s"," ")

ClipChainLoad:
XMLSave("ClipChainData","-" A_Now)
ClipChainData:=RegExReplace(Clipboard,"m)^\s+$") ; v1.1 remove white space from empty lines
If (Asc(SubStr(ClipChainData,1,1)) = 65279) ; fix: remove BOM char from first entry, could mess up a file path...
	ClipChainData:=SubStr(ClipChainData,2)
;StringReplace,ClipChainData,ClipChainData,`r`n`r`n, % Chr(7), All

If CCDelim
	{
	 Loop, parse, CCDelim, CSV
		{
		If (A_LoopField = "\c")
			{
			ClipChainData:=StrReplace(ClipChainData,",",Chr(7))
			continue
			}
		 ClipChainData:=StrReplace(ClipChainData,A_LoopField,Chr(7))
		}
	}

If !CCDelim
	{
	 CCDelim:="`r`n`r`n"
	 ClipChainData:=StrReplace(ClipChainData,CCDelim, Chr(7))
	}

;@Ahk2Exe-IgnoreBegin
#Include *i %A_ScriptDir%\plugins\ClipChainPrivateRules.ahk
;@Ahk2Exe-IgnoreEnd

ClipChainData:=StrSplit(ClipChainData,Chr(7))
CCDelim:=""

ClipChainListview:
Gui, ClipChain:Default
LV_Delete()
for k,v in ClipChainData
	LV_Add("", "", ClipChainHelper(v), A_Index)
LV_Modify(1,"Col1", "||")
XMLSave("ClipChainData")
Return

ClipChainHelper(in) {
	StringReplace, in, in, `r`n, \n, All
	StringReplace, in, in, `n, \n, All
	StringReplace, in, in, `r, \n, All
	return in
}

ClipChainUpdateIndicator:
Gui, ClipChain:Default
Loop, % ClipChainData.MaxIndex()
	LV_Modify(A_Index,"Col1"," ")

If (ClipChainIndex > ClipChainData.MaxIndex()) or (ClipChainIndex <= 1)
	{
	 LV_Modify(1,"Col1","||")
	 LV_Modify(1, "Vis")
	 return
	}

LV_Modify(ClipChainIndex,"Col1",">>")
LV_Modify(ClipChainIndex, "Vis")

Return

ClipChainGuiEscape:
ClipChainGuiClose:
ScriptClipClipChain:=0
Gosub, ClipChainSaveWindowPosition
Gosub, ClipChainSet
Gui, ClipChain:Default
Gui, ClipChain:Submit, Hide
XA_Save("ClipChainData",ClipDataFolder "ClipChain\ClipChain.xml")
Return

ClipChainSaveWindowPosition:
WinGetPos, ClipChainX, ClipChainY, , , CL3ClipChain ahk_class AutoHotkeyGUI
IniWrite, %ClipChainX%, %ClipDataFolder%ClipChain\ClipChain.ini, Settings, ClipChainX
IniWrite, %ClipChainY%, %ClipDataFolder%ClipChain\ClipChain.ini, Settings, ClipChainY
IniWrite, %ClipChainNoHistory%   , %ClipDataFolder%ClipChain\ClipChain.ini, Settings, ClipChainNoHistory
IniWrite, %ClipChainTrans%       , %ClipDataFolder%ClipChain\ClipChain.ini, Settings, ClipChainTrans
If (ClipChainKey = "[press to set]")
	ClipChainKey:=""
IniWrite, %ClipChainKey%         , %ClipDataFolder%ClipChain\ClipChain.ini, Settings, ClipChainKey
IniWrite, %ClipChainSend%        , %ClipDataFolder%ClipChain\ClipChain.ini, Settings, ClipChainSend
IniWrite, %ClipChainPause%       , %ClipDataFolder%ClipChain\ClipChain.ini, Settings, ClipChainPause
IniWrite, %ClipChainPreview%     , %ClipDataFolder%ClipChain\ClipChain.ini, Settings, ClipChainPreview

IniWrite, %ClipChainTrim%     , %ClipDataFolder%ClipChain\ClipChain.ini, Settings, ClipChainTrim
If (ClipChainTrimSet = "[press to set]")
	ClipChainTrimSet:=""
IniWrite, %ClipChainTrimSet%     , %ClipDataFolder%ClipChain\ClipChain.ini, Settings, ClipChainTrimSet
Return

ClipChainMoveUp:
ClipChainLvHandle.Move(1) ; Move selected rows up.
Gosub, ClipChainSet
return

ClipChainMoveDown:
ClipChainLvHandle.Move() ; Move selected rows down.
Gosub, ClipChainSet
return

ClipChainInsertGuiGuiExit:
ClipChainInsertGuiGuiClose:
ClipChainInsertGuiOK:
Gui, ClipChainInsertGui:Submit, Destroy
ClipChainInsertActive:=1
Return

ClipChainInsertGuiCancel:
Gui, ClipChainInsertGui:Destroy
ClipChainInsertActive:=1
Return

ClipChainLoadFile:
Menu, ClipChainLoadFile, Add
Menu, ClipChainLoadFile, Delete
Menu, ClipChainLoadFile, Add
Menu, ClipChainLoadFile, Delete
Menu, ClipChainLoadFile, Add, ClipChain.xml, MenuHandlerClipChainLoadFile
Menu, ClipChainLoadFile, Add
Loop, %ClipDataFolder%ClipChain\*.xml
	{
	 If (A_LoopFileName = "ClipChain.xml")
		Continue
	 Menu, ClipChainLoadFile, Add, %A_LoopFileName%, MenuHandlerClipChainLoadFile
	}
Menu, ClipChainLoadFile, Show
Return

MenuHandlerClipChainLoadFile:
If (XA_Load(ClipDataFolder "ClipChain\" A_ThisMenuItem) = 1) ; the name of the variable containing the array is returned OR the value 1 in case of error
	{
	 MsgBox, 16, ClipChain, %A_ThisMenuItem% seems to be corrupt, starting new empty ClipChain.
	 FileDelete, %ClipDataFolder%ClipChain\%A_ThisMenuItem%
	 ClipChainData:=[]
	}
Gui, ClipChain:Default
LV_Delete()
Gosub, ClipChainListview
Return

; v1.5.1 for #If Hotkeys
ClipChainActive()
	{
	 If (WinExist("CL3ClipChain ahk_class AutoHotkeyGUI") and (ClipChainPause <> 1))
		Return true
	 Else
		Return false
	}

; https://www.autohotkey.com/boards/viewtopic.php?t=77789
HoverTooltip:
If !ClipChainPreview
	Return
If (Mouse_Hwnd = HLV)
	{
	 VarSetCapacity( LVHITTESTINFO, 24, 0 )       ;- allocate structure
	 NumPut( Mouse_X, LVHITTESTINFO, 0, "Int" )   ;- fill coordinate data
	 NumPut( Mouse_Y, LVHITTESTINFO, 4, "Int" )
	 ;- http://msdn.microsoft.com/en-us/library/bb774754%28VS.85%29.aspx
	 SendMessage, LVM_SUBITEMHITTEST, 0, &LVHITTESTINFO,, Ahk_ID %HLV%
	 LVHT_Flags := NumGet( LVHITTESTINFO, 8, "Int" )
	 LVHT_Row := 1 + NumGet( LVHITTESTINFO, 12, "Int" )
	 LVHT_Column := 1 + NumGet( LVHITTESTINFO, 16, "Int" )
	 LV_GetText(Cx,LVHT_Row,2) ; we need second column
	 ;text= You are hovering over Row %LVHT_Row% and Col %LVHT_Column%`n%cx%
	 Text=%cx%
	 Text:=StrReplace(text,"\n","`n")
	 ;WinGetPos, ttX, ttY, , ttHeight, ClipChain
	 If (text = "ClipChain")
		{
		 ToolTip
		 Return
		}
	 text:=text
	 DisplayToolTip(text)
	 SetTimer, ToolTipTimer, 3000
	 Return
	}
ToolTip
Return

DisplayToolTip(text,Columns=50)
	{
	 DispText := RegExReplace(Text, "(.{1," . Columns . "})", "$1`n")
	 ToolTip, % DispText ;, %ttX%, % tty + ttHeight
	}

ToolTipTimer:
MouseGetPos, , , WinID
WinGetTitle, WinTitle, ahk_id %WinID%
If (WinTitle = "CL3ClipChain")
	Return
SetTimer, ToolTipTimer, Off
ToolTip
Return


;--------------
WM_MOUSEMOVE( wparam, lparam, msg, hwnd ) { ; ----------------------------------
	Global Mouse_X, Mouse_Y, Mouse_Hwnd
	Mouse_X := lparam & 0xFFFF       ;- store the mouse position relative
	Mouse_Y := lparam >> 16          ;-     to the window's client areas client area
	Mouse_Hwnd := hwndMouse_Hwnd := hwnd
	Gosub,HoverTooltip
} ; WM_MOUSEMOVE( wparam, lparam, msg, hwnd ) ----------------------------------}

#include %A_ScriptDir%\lib\class_lv_rows.ahk
