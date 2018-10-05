/*

Plugin            : FIFO (Reverse paste)
Purpose           : Paste back in the order in which the entries were added to the clipboard history
Version           : 1.0
CL3 version       : 1.7

History:
- 1.0 Initial version

*/

FifoInit:

FIFOID:=0
FIFOIDCOUNTER:=0
FIFOACTIVE:=0

Return

;^#F10::
hk_fifo:
Gosub, FifoInit
FIFOACTIVE:=1
Gosub, FifoActiveMenu
Gosub, BuildMenuFromFifo
Return

#If FIFOACTIVE

; Paste FIFO MODE
^v::
If (FIFOID = 0) ; just in case we cancelled the FIFO selection menu
	{
	 OnClipboardChange("FuncOnClipboardChange", 0)
	 Clipboard:=History[1].text
	 OnClipboardChange("FuncOnClipboardChange", 1)
	 PasteIt()
	 Sleep 100
	 Gosub, FifoInit
	}
Clipboard:=History[FIFOID].text
PasteIt()
stats.fifo++
FIFOIDCOUNTER++
If (FIFOID = FIFOIDCOUNTER)
	{
	 Gosub, FifoInit
	 Gosub, FifoActiveMenu
	}
Return

; stop FIFO
^+#F10::
Gosub, FifoInit
Gosub, FifoActiveMenu
Return
#If

FifoActiveMenu:
If FIFOACTIVE
	{
	 Menu, tray, Check, &FIFO Active
	}
Else
	{
	 Menu, tray, UnCheck, &FIFO Active
	 TrayTip, FIFO, FIFO Paste Mode Deactivated, 2, 1
	 Gosub, FifoInit
	}
Return