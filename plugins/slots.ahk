/*

Plugin            : Slots
Purpose           : Load & Save 10 quick paste texts
Version           : 1.5

10 Slots
Hotkeys: RCTRL-[1-0] 

History:
- 1.5 Adding QuickSlotsMenu, SlotsNamed
- 1.4 Attempt to prevent XMLRoot error - https://github.com/hi5/CL3/issues/15
- 1.3 Restore current clipboard from History
- 1.2 Added hotkey for QEDL() Ctrl+E (not public)
- 1.1 Bug fix for not correctly updating control (Edit0 vs Slot0) and moved XML to ClipData, improved first time init
- 1.0 first version

*/

SlotsInit:

If !IsObject(Slots)
	{
	 IfExist, %ClipDataFolder%Slots\Slots.xml
		{
		 If (XA_Load(ClipDataFolder "Slots\Slots.xml") = 1) ; the name of the variable containing the array is returned OR the value 1 in case of error
			{
			 MsgBox, 16, Slots, Slots.xml seems to be corrupt, starting a new Slots.xml
			 FileDelete, %ClipDataFolder%Slots\Slots.xml
			 Slots:=[]
			}
		}
	 else
		{
		 Slots:=[]
		 Loop, 10
			Slots[A_Index-1]:="Slot" A_Index-1 "a"
		}
	}

If !IsObject(SlotsNamed)
	 IfExist, %ClipDataFolder%Slots\SlotsNamed.xml
		 XA_Load(ClipDataFolder "Slots\SlotsNamed.xml")

x:=10
y:=10
Index:=0

Gui, Slots:font,% dpi("s8")
Loop, 10
	{
	 Index++
	 If (Index = 10)
		Index:=0
	 Gui, Slots:Add, Text, % dpi("x" x " y" y),Slot #%Index% [RCtrl + %Index%]
	 Gui, Slots:Add, Edit, % dpi("w290 h60 vSlot" Index), % Slots[Index]
	 y+=80
	 if (A_Index = 5)
		y:=10
	 if (A_Index = 5)
		x:=310
	}
Gui, Slots:Add, Button, % dpi("x10 gSlotsSave"), &Save Slots (slots.xml)
Gui, Slots:Add, Button, % dpi("xp130 gSlotsSaveAs"), Save &As (name.xml)
Gui, Slots:Add, Button, % dpi("xp130 gLoadSlots"), &Load (name.xml)
Gui, Slots:Add, Button, % dpi("xp253 gSlotsClose"), &Close window
Return

;^#F12::
hk_slots:
If !WinExist("CL3Slots ahk_class AutoHotkeyGUI")
	Gui, Slots:Show, ,CL3Slots
else
	Gui, Slots:Hide
Return

;>^1::
;>^2::
;>^3::
;>^4::
;>^5::
;>^6::
;>^7::
;>^8::
;>^9::
;>^0::
hk_slotpaste:
OnClipboardChange("FuncOnClipboardChange", 0)
If (SlotKey = "")
	SlotKey:=SubStr(A_thisHotkey,0)
;If (SlotKey = 10) ; if we came via QuickSlotsMenuHandler
;	SlotKey:=0
Clipboard:=Slots[SlotKey]
PasteIt()
Sleep 100
Clipboard:=History[1].text
OnClipboardChange("FuncOnClipboardChange", 1)
stats.slots++
SlotKey:=""
Return

hk_slotpastenamed:
OnClipboardChange("FuncOnClipboardChange", 0)
Clipboard:=SlotsNamed[SlotKey]
PasteIt()
Sleep 100
Clipboard:=History[1].text
OnClipboardChange("FuncOnClipboardChange", 1)
stats.slots++
SlotKey:=""
Return

~Esc::
SlotsGuiClose:
SlotsClose:
Gui, Slots:Cancel
Return

SlotsSave:
Gui, Slots:Submit, Hide
XMLSave("Slots","-" A_Now)
Index:=0
Loop, 10
	{
	 Slots[Index]:=Slot%Index%
	 Index++
	}
XMLSave("Slots")
Return

SlotsSaveAs:
SaveAsName:=""
Gui, Slots:Submit, Hide
InputBox, SaveAsName, Name for XML, Save slots as
If (SaveAsName = "")
	{
	 MsgBox, Enter filename!`nSlots not saved.
	 Gui, Slots:Show
	 Return
	}
XMLSave("Slots","-" A_Now)
Index:=0
Loop, 10
	{
	 Slots[Index]:=Slot%Index%
	 Index++
	}
StringReplace, SaveAsName, SaveAsName, .xml,,All
XA_Save("Slots", ClipDataFolder "Slots\" SaveAsName ".xml") ; put variable name in quotes
Return

LoadSlots:
Menu, SlotsMenu, Add
Menu, SlotsMenu, Delete
Menu, SlotsMenu, Add, Slots.xml, MenuHandlerSlots
Menu, SlotsMenu, Add
Loop, %ClipDataFolder%Slots\*.xml
	{
	 If (A_LoopFileName = "slots.xml")
		Continue
	 Menu, SlotsMenu, Add, %A_LoopFileName%, MenuHandlerSlots
	}
Menu, SlotsMenu, Show
Return

MenuHandlerSlots:
XMLSave("Slots","-" A_Now)
Slots:=[]
If (XA_Load(ClipDataFolder "Slots\" A_ThisMenuItem) = 1) ; the name of the variable containing the array is returned OR the value 1 in case of error
	{
	 MsgBox, 16, Slots, %A_ThisMenuItem% seems to be corrupt, starting a new Slots file
	 FileDelete, %ClipDataFolder%Slots\%A_ThisMenuItem%
	 Slots:=[]
	 Loop, 10
		Slots[Index-1]:="Slot" A_Index-1 "a"
	}
Index:=0	
Loop, 10
	{
	 GuiControl,Slots:, Slot%Index%, % Slots[Index]
	 Index++
	}
Return

QuickSlotsMenu:
Try
	Menu, QuickSlotsMenu, Delete
Menu, QuickSlotsMenu, Add, % "&1. " DispMenuText(SubStr(Slots[1],1,500),-1), QuickSlotsMenuHandler
Menu, QuickSlotsMenu, Add, % "&2. " DispMenuText(SubStr(Slots[2],1,500),-1), QuickSlotsMenuHandler
Menu, QuickSlotsMenu, Add, % "&3. " DispMenuText(SubStr(Slots[3],1,500),-1), QuickSlotsMenuHandler
Menu, QuickSlotsMenu, Add, % "&4. " DispMenuText(SubStr(Slots[4],1,500),-1), QuickSlotsMenuHandler
Menu, QuickSlotsMenu, Add, % "&5. " DispMenuText(SubStr(Slots[5],1,500),-1), QuickSlotsMenuHandler
Menu, QuickSlotsMenu, Add, % "&6. " DispMenuText(SubStr(Slots[6],1,500),-1), QuickSlotsMenuHandler
Menu, QuickSlotsMenu, Add, % "&7. " DispMenuText(SubStr(Slots[7],1,500),-1), QuickSlotsMenuHandler
Menu, QuickSlotsMenu, Add, % "&8. " DispMenuText(SubStr(Slots[8],1,500),-1), QuickSlotsMenuHandler
Menu, QuickSlotsMenu, Add, % "&9. " DispMenuText(SubStr(Slots[9],1,500),-1), QuickSlotsMenuHandler
Menu, QuickSlotsMenu, Add, % "&0. " DispMenuText(SubStr(Slots[0],1,500),-1), QuickSlotsMenuHandler
Menu, QuickSlotsMenu, Add
Menu, QuickSlotsMenu, Add, &Show Slots, QuickSlotsMenuHandler
If IsObject(SlotsNamed)
	{
	 Menu, QuickSlotsMenu, Add
	 for k, v in SlotsNamed
		Menu, QuickSlotsMenu, Add, % "&" k ": " DispMenuText(SubStr(v,1,500),-1), QuickSlotsMenuHandler
	 Menu, QuickSlotsMenu, Add, &x Remove Named Slot, QuickSlotsMenuHandler	
	}
;Menu, QuickSlotsMenu, Show
Return

QuickSlotsMenuHandler:
If (A_ThisMenuItem = "&x Remove Named Slot")
	{
	 for k, v in SlotsNamed
		DeleteEntry .= k ","
	 InputBox, DeleteEntry, Delete Named Slot, Enter name of slot(s) to delete (exact and csv), , 500, 170, , , , , %DeleteEntry%
	 If ErrorLevel
		return
	 Loop, parse, DeleteEntry, CSV
		SlotsNamed.Delete(A_LoopField)
	 XA_Save("SlotsNamed", ClipDataFolder "Slots\SlotsNamed.xml")
	 Gosub, QuickSlotsMenu
	 DeleteEntry:=""
	}
If (A_ThisMenuItem = "&Show Slots")
	Gosub, hk_slots
else
	{
	 SlotKey:=A_ThisMenuItemPos
	 If (SlotKey = 10)
		SlotKey:=0
	 if (SlotKey < 10)
		Gosub, hk_slotpaste
	 SlotKey:=LTrim(StrSplit(A_ThisMenuItem,":").1,"&")
	 Gosub, hk_slotpastenamed
	 SlotKey:=""
	}	
Return

; not public
;@Ahk2Exe-IgnoreBegin
#include *i %A_ScriptDir%\plugins\MyQEDLG-Slots.ahk
;@Ahk2Exe-IgnoreEnd
