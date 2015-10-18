/*

Plugin            : Slots
Purpose           : Load & Save 10 quick paste texts
Version           : 1.0
CL3 version       : 1.2

10 Slots
Hotkeys: RCTRL-[1-0] 

*/

SlotsInit:
Gui, Slots:Destroy
; for first run only, make sure the slots object will have content (alebeit empty)
IfExist, %A_ScriptDir%\slots.xml
	{
	 XA_Load(A_ScriptDir "\slots.xml") ; the name of the variable containing the array is returned 
	}
else
	{
	 Slots:=[]
	 Loop, 10
	 	Slots[A_Index-1]:=""
	}

x:=10
y:=10
Index:=0
Loop, 10
	{
	 Index++
	 If (Index = 10)
	 	Index:=0
	 Gui, Slots:Add, Text, x%x% y%y% ,Slot #%Index% [RCtrl + %Index%]
	 Gui, Slots:Add, Edit, w290 h60 vSlot%Index%, % Slots[Index]
	 y+=80
	 if (A_Index = 5)
	 	y:=10
	 if (A_Index = 5)
	 	x:=310
	}
Gui, Slots:Add, Button, x10 gSlotsSave, &Save Slots (slots.xml)
Gui, Slots:Add, Button, xp130 gSlotsSaveAs, Save &As (name.xml)
Gui, Slots:Add, Button, xp130 gLoadSlots, &Load (name.xml)
Gui, Slots:Add, Button, xp253 gSlotsClose, &Close window
Return

^#F12::
Gosub, SlotsInit
Gui, Slots:Show
Return

>^1::
>^2::
>^3::
>^4::
>^5::
>^6::
>^7::
>^8::
>^9::
>^0::
Clipboard:=Slots[SubStr(A_thisHotkey,0)]
Send ^v
Return

~Esc::
SlotsGuiClose:
SlotsClose:
Gui, Slots:Cancel
Return

SlotsSaveAs:
Gui, Slots:Submit, Hide
InputBox, SaveAsName, Name for XML, Save slots as
Index:=0
Loop, 10
	{
	 Slots[Index]:=Slot%Index%
	 Index++
	}
StringReplace, SaveAsName, SaveAsName, .xml,,All
XA_Save("Slots", A_ScriptDir "\" SaveAsName ".xml") ; put variable name in quotes
Return

LoadSlots:
Menu, SlotsMenu, Add
Menu, SlotsMenu, Delete
Loop, %A_ScriptDir%\*.xml
	{
	 If (A_LoopFileName = "history.xml")
	 	Continue
	 Menu, SlotsMenu, Add, %A_LoopFileName%, MenuHandlerSlots
	}
Menu, SlotsMenu, Show
Return

MenuHandlerSlots:
Try
	{
	 XA_Load(A_ScriptDir "\" A_ThisMenuItem) ; the name of the variable containing the array is returned
	}
Catch
	{
	 Slots:=[]
	 Loop, 10
	 	 	Slots[Index-1]:="Slot" A_Index-1 "a"
	}
Index:=0	
Loop, 10
	{
	 GuiControl,Slots:, Edit%Index%, % Slots[Index]
	 Index++
	}
Return

SlotsSave:
Gui, Submit, Hide
Index:=0
Loop, 10
	{
	 Slots[Index]:=Slot%Index%
	 Index++
	}
XA_Save("Slots", "Slots.xml") ; put variable name in quotes
Return