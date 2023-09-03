/*

Plugin            : AutoReplace()
Version           : 1.7
CL3 version       : 1.4

History:
- 1.7 Don't use clipboard in String Replacement but text variable
- 1.6 Attempt to prevent XMLRoot error - https://github.com/hi5/CL3/issues/15
- 1.5 Optional tray menu "replace actions" indicator (reverted change, code commented, see "TrayTip" code near the end)
- 1.4 Added fixed setting for Bypass (excell.exe) to avoid problems pasting content in Excel, default setting inactive
- 1.3 Added A_Space/A_Tab/%A_Space%/%A_Tab% for space/tab Replacement
- 1.2 Added 'Try' as a fix for rare issue

*/

AutoReplaceInit:
If !IsObject(AutoReplace)
	{
	 IfExist, %ClipDataFolder%AutoReplace\AutoReplace.xml
		{
		 If (XA_Load(ClipDataFolder "AutoReplace\AutoReplace.xml") = 1) ; the name of the variable containing the array is returned OR the value 1 in case of error
			{
			 MsgBox, 16, AutoReplace, AutoReplace.xml seems to be corrupt, starting a new empty AutoReplace.xml.
			 FileDelete, %ClipDataFolder%AutoReplace\AutoReplace.xml
			 AutoReplace:=[]
			}
		}
	 else
		{
		 AutoReplace:=[]
		}
	}

If !AutoReplace.Settings.HasKey("Active")
	AutoReplace["Settings","Active"]:=0           ; default setting change from active to inactive v1.95
If !AutoReplace.Settings.HasKey("Bypass")
	AutoReplace["Settings","Bypass"]:="excel.exe" ; default fixed setting 

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
XMLSave("AutoReplace","-" A_Now)
AutoReplace.RemoveAt(Rules)
;XA_Save("AutoReplace", ClipDataFolder "AutoReplace\AutoReplace.xml")
XMLSave("AutoReplace")
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
AutoReplace.Settings.Bypass:=Bypass
If (Rules = "")
	Rules:=1
If (Find = "")
	Return
XMLSave("AutoReplace","-" A_Now)
name:=name ? name : "Unnamed rule"
AutoReplace[Rules,"name"]:=name
AutoReplace[Rules,"type"]:=type
AutoReplace[Rules,"find"]:=find
AutoReplace[Rules,"replace"]:=replace
;XA_Save("AutoReplace", ClipDataFolder "AutoReplace\AutoReplace.xml")
XMLSave("AutoReplace")
Return

AutoReplaceCancel:
Gui, AutoReplace:Hide
Return

AutoReplace()
	{
	 global AutoReplace,IconExe,AutoReplaceTrayTip,ClipboardHistoryToggle
	 if !AutoReplace.Settings.Active ; bypass AutoReplace
		Return clipboard
	 if ClipboardHistoryToggle ; bypass AutoReplace
		Return clipboard
	 if RegExMatch(IconExe, "im)\\(" StrReplace(AutoReplace.Settings.Bypass,",","|") ")$") ; bypass AutoReplace
		Return
	 ClipStore:=ClipboardAll             ; store all formats
	 ClipStoreText:=Clipboard            ; store text
	 ClipStoreTextReplace:=ClipStoreText ; store text

	 OnClipboardChange("FuncOnClipboardChange", 0)
	 ChangedClipboard:=0,OutputVarCount:=0
	 for k, v in AutoReplace
	 {
		if (v.type = "0") or (v.type = "")
			{
			 Try
				{
				 ReplaceString:=v.replace
				 if ReplaceString = %A_Space%
					ReplaceString:=" "
				 else if ReplaceString = A_Space
					ReplaceString:=" "
				 if ReplaceString = %A_Tab%
					ReplaceString:="	"
				 else if ReplaceString = A_Tab
					ReplaceString:="	"
				 ClipStoreTextReplace:=StrReplace(ClipStoreTextReplace, v.find, ReplaceString, OutputVarCount)
				 If OutputVarCount
					ChangedClipboard+=OutputVarCount
				}
			}
		else if (v.type = "1")
			{
			 Try
				{
				 ClipStoreTextReplace:=RegExReplace(ClipStoreTextReplace, v.find, v.replace, OutputVarCount)
				 If OutputVarCount
					ChangedClipboard+=OutputVarCount
				}
			}
	 }
	 if (Clipboard = ClipStoreText) ; if we haven't actually modified the text make sure we restore all formats
		 Clipboard:=ClipStore
	 ClipStore:=""
	 If ChangedClipboard
		{
		 Clipboard:=ClipStoreTextReplace
		 If AutoReplaceTrayTip
			OSDTIP_Pop("CL3 AutoReplace", ChangedClipboard " replacement(s)", -750,"W130 H60 U1")
		}
	 ClipStoreTextReplace:=""
	 OnClipboardChange("FuncOnClipboardChange", 1)
	 Return
	}

AutoReplaceMenu:
If AutoReplace.Settings.Active
	Menu, tray, Check, &AutoReplace Active
Else
	Menu, tray, UnCheck, &AutoReplace Active
Return

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

; OSDTIP_Pop(MainText, SubText, TimeOut, Options, FontName, Transparency)
; OSDTIP_Pop("Notification", "Message", -3000) ; #Persistent required
OSDTIP_Pop(P*) {                            ; OSDTIP_Pop v0.55 by SKAN on D361/D36E @ tiny.cc/osdtip 
Local
Static FN:="", ID:=0, PM:="", PS:="" 

  If !IsObject(FN)
    FN := Func(A_ThisFunc).Bind(A_ThisFunc) 

  If (P.Count()=0 || P[1]==A_ThisFunc) {
    OnMessage(0x202, FN, 0),  OnMessage(0x010, FN, 0)                   ; WM_LBUTTONUP, WM_CLOSE 
    SetTimer, %FN%, OFF
    DllCall("AnimateWindow", "Ptr",ID, "Int",200, "Int",0x50004)        ; AW_VER_POSITIVE | AW_SLIDE
    Progress, 10:OFF                                                    ; | AW_HIDE
    Return ID:=0
  }

  MT:=P[1], ST:=P[2], TMR:=P[3], OP:=P[4], FONT:=P[5] ? P[5] : "Segoe UI"
  Title := (TMR=0 ? "0x0" : A_ScriptHwnd) . ":" . A_ThisFunc
  
  If (ID) {
    Progress, 10:, % (ST=PS ? "" : PS:=ST), % (MT=PM ? "" : PM:=MT), %Title%
    OnMessage(0x202, FN, TMR=0 ? 0 : -1)                                ; v0.55
    SetTimer, %FN%, % Round(TMR)<0 ? TMR : "OFF" 
    Return ID
  }                                                                                                        

  If ( InStr(OP,"U2",1) && FileExist(WAV:=A_WinDir . "\Media\Windows Notify.wav") )
    DllCall("winmm\PlaySoundW", "WStr",WAV, "Ptr",0, "Int",0x220013)    ; SND_FILENAME | SND_ASYNC   
                                                                        ; | SND_NODEFAULT   
  DetectHiddenWindows, % ("On", DHW:=A_DetectHiddenWindows)             ; | SND_NOSTOP | SND_SYSTEM  
  SetWinDelay, % (-1, SWD:=A_WinDelay)                            
  DllCall("uxtheme\SetThemeAppProperties", "Int",0)
  Progress, 10:C00 ZH1 FM9 FS10 CWF0F0F0 CT101010 %OP% B1 M HIDE,% PS:=ST, % PM:=MT, %Title%, %FONT%
  DllCall("uxtheme\SetThemeAppProperties", "Int",7)                     ; STAP_ALLOW_NONCLIENT
                                                                        ; | STAP_ALLOW_CONTROLS
  WinWait, %Title% ahk_class AutoHotkey2                                ; | STAP_ALLOW_WEBCONTENT
  WinGetPos, X, Y, W, H                                                 
  SysGet, M, MonitorWorkArea
  WinMove,% "ahk_id" . WinExist(),,% MRight-W,% MBottom-(H:=InStr(OP,"U1",1) ? H : Max(H,100)), W, H
  If ( TRN:=Round(P[6]) & 255 )
    WinSet, Transparent, %TRN% 
  ControlGetPos,,,,H, msctls_progress321       
  If (H>2) {
    ColorMQ:=Round(P[7]),  ColorBG:=P[8]!="" ? Round(P[8]) : 0xF0F0F0,  SpeedMQ:=Round(P[9])
    Control, ExStyle, -0x20000,        msctls_progress321               ; v0.55 WS_EX_STATICEDGE
    Control, Style, +0x8,              msctls_progress321               ; PBS_MARQUEE
    SendMessage, 0x040A, 1, %SpeedMQ%, msctls_progress321               ; PBM_SETMARQUEE
    SendMessage, 0x0409, 1, %ColorMQ%, msctls_progress321               ; PBM_SETBARCOLOR
    SendMessage, 0x2001, 1, %ColorBG%, msctls_progress321               ; PBM_SETBACKCOLOR
  }  
  DllCall("AnimateWindow", "Ptr",WinExist(), "Int",200, "Int",0x40008)  ; AW_VER_NEGATIVE | AW_SLIDE
  SetWinDelay, %SWD%
  DetectHiddenWindows, %DHW%
  If (Round(TMR)<0)
    SetTimer, %FN%, %TMR%
  OnMessage(0x202, FN, TMR=0 ? 0 : -1),  OnMessage(0x010, FN)           ; WM_LBUTTONUP,  WM_CLOSE
Return ID:=WinExist()
}
