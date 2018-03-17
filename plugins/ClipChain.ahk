/*

Plugin            : ClipChain
Purpose           : Cycle through a predefined clipboard history on each paste
Version           : 1.4
CL3 version       : 1.5

History:
- 1.4 Added QEDL() for edit and insert (not public)
- 1.3 Added DoubleClick to paste and progress ClipChain
- 1.2 Fixed LV_Modify empty parameters because of AutoHotkey v1.1.23.03 update
- 1.1 Added minor fix for "non-empty" empty lines?

*/

ClipChainInit:
IniRead, ClipChainX          , %A_ScriptDir%\ClipData\ClipChain\ClipChain.ini, Settings, ClipChainX, 100
IniRead, ClipChainY          , %A_ScriptDir%\ClipData\ClipChain\ClipChain.ini, Settings, ClipChainY, 100
IniRead, ClipChainNoHistory  , %A_ScriptDir%\ClipData\ClipChain\ClipChain.ini, Settings, ClipChainNoHistory , 0
IniRead, ClipChainTrans      , %A_ScriptDir%\ClipData\ClipChain\ClipChain.ini, Settings, ClipChainTrans     , 0
IniRead, ClipChainPause      , %A_ScriptDir%\ClipData\ClipChain\ClipChain.ini, Settings, ClipChainPause     , 0

If (ClipChainX = "") or (ClipChainX = "ERROR")
	ClipChainX:=100
If (ClipChainY = "") or (ClipChainY = "ERROR")
	ClipChainy:=100

If !IsObject(ClipChainData)
	{
	 IfExist, %A_ScriptDir%\ClipData\ClipChain\ClipChain.xml
		{
		 XA_Load(A_ScriptDir "\ClipData\ClipChain\ClipChain.xml") ; the name of the variable containing the array is returned 
		}
	 else
		{
		 ClipChain:=[]
		}
	}

ClipChainIndex:=1

Menu, ClipChainMenu, Add
Menu, ClipChainMenu, Delete

Menu, ClipChainMenu, Add, Load from Clipboard, ClipChainLoad
Menu, ClipChainMenu, Add
Menu, ClipChainMenu, Add, Load from File, ClipChainLoadFile
Menu, ClipChainMenu, Add, Save to File, ClipChainSaveFile
Menu, ClipChainMenu, Add
Menu, ClipChainMenu, Add, Clear ClipChain, ClipChainClear

Gui, ClipChain:Default
Gui, ClipChain:Font, % dpi("s8")
Gui, ClipChain:+Border +ToolWindow +AlwaysOnTop +E0x08000000 ; +E0x08000000 = WS_EX_NOACTIVATE ; ontop and don't activate it while you click on the Gui
Gui, ClipChain:Add, Listview, % dpi("x0 y0 w185 h350 NoSortHdr grid vLVCGIndex gClipChainClicked hwndHLV"),?|ClipChain|IDX
LV_ModifyCol(1,dpi()*25)
LV_ModifyCol(2,dpi()*160)
LV_ModifyCol(3,*0)
;LV_ModifyCol(2,100) ; debug
;LV_ModifyCol(3,30)  ; debug
Gosub, ClipChainListview

Gui, ClipChain:font,% dpi("s8")
Gui, ClipChain:Add, GroupBox, % dpi("x2 yp+355 w181 h50"), Chain(s)
Gui, ClipChain:Add, Button, % dpi("xp+8  yp+18 w26 h26 gClipChainMoveUp    "), % Chr(0x25B2) ; ▲
Gui, ClipChain:Add, Button, % dpi("xp+28 yp    w26 h26   gClipChainMoveDown"), % Chr(0x25BC) ; ▼
Gui, ClipChain:Add, Button, % dpi("xp+28 yp    w26 h26   gClipChainInsert  "), Ins
Gui, ClipChain:font,% dpi("s11") ; " Wingdings"
Gui, ClipChain:Add, Button, % dpi("xp+28 yp    w26 h26   gClipChainEdit    "), % Chr(0x270E) ; ✎ ; % Chr(33) ; Edit (pencil) 
Gui, ClipChain:font
Gui, ClipChain:font, % dpi("s12 bold")
Gui, ClipChain:Add, Button, % dpi("xp+28 yp    w26 h26   gClipChainDel     "), % Chr(0x1f5d1) ; trashcan ; X ; Del (X)
Gui, ClipChain:font
Gui, ClipChain:font,% dpi("s11") ; " Wingdings " 
Gui, ClipChain:Add, Button, % dpi("xp+28 yp    w26 h26   gClipChainMenu    "), % Chr(0x1F4C2) ; open folder 📂; % Chr(49)
Gui, ClipChain:font
Gui, ClipChain:font,% dpi("s8")
Gui, ClipChain:Add, GroupBox, % dpi("x2 yp+40 w181 h80"), Options
Gui, ClipChain:Add, Checkbox, % dpi("xp+10 yp+18 w75 h24 vClipChainNoHistory gClipChainCheckboxes"), No History
Gui, ClipChain:Add, Checkbox, % dpi("xp+80 yp    w85 h24 vClipChainTrans     gClipChainCheckboxes"), Transparent
Gui, ClipChain:Add, Checkbox, % dpi("xp-80 yp+30 w75 h24 vClipChainPause     gClipChainCheckboxes"), Pause
Gui, ClipChain:Add, Button  , % dpi("xp+80 yp    w85 h24 gClipChainGuiClose"), Close ClipChain

GuiControl, ClipChain:, ClipChainNoHistory  , %ClipChainNoHistory%
GuiControl, ClipChain:, ClipChainTrans      , %ClipChainTrans%
GuiControl, ClipChain:, ClipChainPause      , %ClipChainPause%

Gosub, ClipChainCheckboxes
ClipChainLvHandle := New LV_Rows(HLV)
Return

#IfWinExist CL3ClipChain ahk_class AutoHotkeyGUI
~LButton::
If ClipChainPause
	Return
If (A_TimeSincePriorHotkey<400) and (A_TimeSincePriorHotkey<>-1)
	{ ; check if you doubleclicked on the listview if so move away focus from listview otherwise we couldn't set the new active item by double clicking in the LV
	 ControlGetFocus, CL3ClipChainListview, CL3ClipChain ahk_class AutoHotkeyGUI
	 If (CL3ClipChainListview = "SysListView321")
	 	{
	 	 ControlFocus, Button12, CL3ClipChain ahk_class AutoHotkeyGUI
	 	 Return
	 	}
	 Gosub, ClipChainPasteDoubleClick
	}
Return
#IfWinActive

^#F11::
If !WinExist("CL3ClipChain ahk_class AutoHotkeyGUI")
	Gui, ClipChain:Show, % dpi("w185 NA x") ClipChainX " y" ClipChainY, CL3ClipChain
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
XA_Save("ClipChainData", A_ScriptDir "\ClipData\ClipChain\" SaveAsName ".xml") ; put variable name in quotes
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
Return

ClipChainInsertGui:
ClipChainInsertActive:=0

; not public
#include *i %A_ScriptDir%\plugins\MyQEDLG-ClipChain.ahk

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
Return

ClipChainCheckboxes:
Gui, ClipChain:Default
Gui, ClipChain:Submit, NoHide

If ClipChainNoHistory
	ScriptClipClipChain:=1
else If !ClipChainNoHistory
	ScriptClipClipChain:=0

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

ClipChainLoad:
ClipChainData:=RegExReplace(Clipboard,"m)^\s+$") ; v1.1 remove white space from empty lines
If (Asc(SubStr(ClipChainData,1,1)) = 65279) ; fix: remove BOM char from first entry, could mess up a filepath...
	ClipChainData:=SubStr(ClipChainData,2)
StringReplace,ClipChainData,ClipChainData,`r`n`r`n, % Chr(7), All
#Include *i %A_ScriptDir%\plugins\ClipChainPRIVATERULES.ahk
ClipChainData:=StrSplit(ClipChainData,Chr(7))
 
ClipChainListview:
Gui, ClipChain:Default
LV_Delete()
for k,v in ClipChainData
	LV_Add("", "", ClipChainHelper(v), A_Index)
LV_Modify(1,"Col1", "||")
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
XA_Save("ClipChainData",A_ScriptDir "\ClipData\ClipChain\ClipChain.xml")
Return

ClipChainSaveWindowPosition:
WinGetPos, ClipChainX, ClipChainY, , , CL3ClipChain ahk_class AutoHotkeyGUI
IniWrite, %ClipChainX%, %A_ScriptDir%\ClipData\ClipChain\ClipChain.ini, Settings, ClipChainX
IniWrite, %ClipChainY%, %A_ScriptDir%\ClipData\ClipChain\ClipChain.ini, Settings, ClipChainY
IniWrite, %ClipChainNoHistory%   , %A_ScriptDir%\ClipData\ClipChain\ClipChain.ini, Settings, ClipChainNoHistory
IniWrite, %ClipChainTrans%       , %A_ScriptDir%\ClipData\ClipChain\ClipChain.ini, Settings, ClipChainTrans
IniWrite, %ClipChainPause%       , %A_ScriptDir%\ClipData\ClipChain\ClipChain.ini, Settings, ClipChainPause
Return

#If WinExist("CL3ClipChain ahk_class AutoHotkeyGUI") and (ClipChainPause <> 1)

~LButton::
If (A_TimeSincePriorHotkey<400) and (A_TimeSincePriorHotkey<>-1)
	Gosub, ClipChainPasteDoubleClick
Return

$^v::
ClipChainPasteDoubleClick:
Gui, ClipChain:Default
Gui, ClipChain:Submit, NoHide
If (ClipChainIndex > ClipChainData.MaxIndex())
	{
	 ClipChainIndex:=1
	}
Clipboard:=ClipChainData[ClipChainIndex]
PasteIt()
ClipChainIndex++
Gosub, ClipChainUpdateIndicator
Return
#If

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
Loop, %A_ScriptDir%\ClipData\ClipChain\*.xml
	{
	 If (A_LoopFileName = "ClipChain.xml")
		Continue
	 Menu, ClipChainLoadFile, Add, %A_LoopFileName%, MenuHandlerClipChainLoadFile
	}
Menu, ClipChainLoadFile, Show
Return

MenuHandlerClipChainLoadFile:
Try
	{
	 XA_Load(A_ScriptDir "\ClipData\ClipChain\" A_ThisMenuItem) ; the name of the variable containing the array is returned
	}
Catch
	{
	 ClipChainData:=[]
	}
Gui, ClipChain:Default
LV_Delete()
Gosub, ClipChainListview
Return

#include %A_ScriptDir%\lib\class_lv_rows.ahk
