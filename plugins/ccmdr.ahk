/*

Plugin            : ccmdr (optional via settings.ini)
Purpose           : Allow for (batch) operations on clipboard history vs the
                    usual one by one operations via standard CL3 options.
                    see docs\ccmdr.md
Version           : 1.0
CL3 version       : v1.94

History:
- 1.0 initial version

*/

ccmdersetup:
HelpCommands:={	b:"Burst seperator (\n, \t, \\, char or word)"
	, i : "Insert IDx"
	, f : "FIFO IDx, e=enter, t=tab"
	, l : "Lower case IDx or range (IDx-IDy)"
	, p : "Paste IDx (repeat) or range (IDx-IDy), e=enter, t=tab"
	, r : "Reverse"
	, s : "Store in Slot (1-10) or name"
	, t : "Title case IDx or range (IDx-IDy)"
	, u : "Upper case IDx or range (IDx-IDy)"
	, y : "Yank IDx or range (IDx-IDy)"
	, ___: "dummy" }

for k, v in HelpCommands
	if (k = "___")
		continue
	else
		HelpEntryText.= k ","
HelpEntryText:=Trim(HelpEntryText,",")
Sort, HelpEntryText, `,
HelpEntryText:=StrReplace(HelpEntryText,",",", ")
Gui, cmdr:New, -Caption +Border ; +ToolWindow
Gui, cmdr:Font, % dpi("s10")
Gui, cmdr:Add, Text, ,Action: [ hint: %HelpEntryText% ]
Gui, cmdr:Add, Edit, % dpi("gCmdr vCmd w350 hwndCmdHwnd")
Gui, cmdr:Add, Text, % dpi("vCmdrFeedback w350"), enter command
Gui, cmdr:Add, Button, Hidden Default gCmdExec, OK
Return

;#j::
hk_cmdr:
If !WinExist("CL3:cmdr ahk_class AutoHotkeyGUI")
	{
	 Gui, cmdr:Show, AutoSize center, CL3:cmdr
	 GuiControl, cmdr:Text,cmd,
	}
else
	Gosub, CmdrGuiClose
Return

#IfWinActive CL3:cmdr
Esc::
CmdrGuiClose:
Gui, cmdr:Hide
GuiControl, cmdr:Text,cmd,
Cmd:=""
Return
#IfWinActive

Cmdr:
Gui, cmdr:Submit,NoHide
Help:=SubStr(cmd,1,1)
If (Help = "r")
	{
	 Reverse:=1
	 Help:=SubStr(cmd,2,1)
	 If (Help = "")
		Help:="r"
	}
if !HelpCommands.HasKey(Help)
	{
	 GuiControl, cmdr:Text,cmd,
	 GuiControl, cmdr:Text,CmdrFeedback,enter command
	 Return
	}
If Reverse and (Help = "b")
	GuiControl, cmdr:,CmdrFeedback,% "Reverse " HelpCommands[help]
else
	GuiControl, cmdr:,CmdrFeedback,% HelpCommands[help]
Help:="",Reverse:=0
Return

CmdExec:
Gui, cmdr:Submit,Hide
Command(cmd)
Help:="",cmd:=""
Return

Command(cmd)
	{
	 global History,Slots
	 cmd:=trim(cmd," ")
	 Command:=SubStr(cmd,1,1)
	 if (Command = "r") ; for burst, paste
		{
		 Reverse:=1
		 Command:=SubStr(cmd,2,1)
		 cmd:=SubStr(cmd,3)
		}
	 else
		cmd:=SubStr(cmd,2)

	 if (cmd = "")
	 	cmd:=1 ; so y,u,l enter is y1,u1,l1 for example

	 /*
	 u	uppercase
	 l	lowercase
	 t	titlecase
		u5 -> uppercase a b c d e
		u2-4 -> uppercase b c d
	 */
	 if Command in u,l,t
		{
		 if (Command = "u")
			callfunc:="Upper"
		 if (Command = "l")
			callfunc:="Lower"
		 if (Command = "t")
			callfunc:="Title"
		 if RegExMatch(cmd,"i)^[a-z]$")
			cmd:=cmdrAsc2Number(cmd)

		 cmd:=cmdrRange(cmd)

		 OnClipboardChange("FuncOnClipboardChange", 0)

		 Loop, parse, cmd, CSV
			History[A_LoopField].text:=%callfunc%(History[A_LoopField].text)

		 if RegExMatch(cmd,"\b1\b") ; if we've modified the current clipboard ensure we update it 
			Clipboard:=History[1].text

		 OnClipboardChange("FuncOnClipboardChange", 1)

		 return
		}

	 /*
	 s	slot
		s1-0 -> store in slot 1 .. 10
		sname -> store in NamedSlots
	 */

	 if (Command = "s")
		{
		 RegExMatch(cmd,"^(\d+)",SlotID)
		 if SlotID is number
			{
			 if (SlotID = 10)
				SlotID:=0
			 if SlotID between 0 and 9
				{
				 Slots[SlotID]:=History[1].text
				 GuiControl, Slots:Text, Slot%SlotID%, % History[1].text ; update gui which we already setup in the Slots plugins
				}
			 else
				{
				 TrayTip, CL3:cmdr, Invalid SlotID`n(Command ignored), 1, 3 ; one second, error icon
				}
			}
		 ; TODO named Slots
		 return
		}
	
	 /*
	 i	insert
		i4 insert at position d
	 */
	 if (Command = "i")
		{
		 if RegExMatch(cmd,"i)^[a-z]$")
			cmd:=cmdrAsc2Number(cmd)
		 cmd++
		 if cmd is number
			{
			 History.InsertAt(cmd,{"text": clipboard,"icon":""})
			 History.Remove(1)
			 OnClipboardChange("FuncOnClipboardChange", 0)
			 Clipboard:=History[1].text
			 OnClipboardChange("FuncOnClipboardChange", 1)
			}
		}

	 /*
	 f	fifo
		f3 -> paste c b a
		f3t -> paste c tab b tab a tab
		f3e -> paste c enter
	 */
	 if (Command = "f")
		{
		 if (SubStr(cmd,0) = "t")
			{
			 sendtab:=1
			 cmd:=RTrim(cmd,"t")
			}
		 if (SubStr(cmd,0) = "e")
			{
			 sendenter:=1
			 cmd:=RTrim(cmd,"e")
			}
		 Loop, % cmd
			newcmd .= cmd-A_Index+1 ","
		 cmd:=Rtrim(newcmd,",")
		 newcmd:=""
		 range:=1
		 command:="p"
		}

	 /*
	 p	paste
		p3 -> paste history 3 times
		p3t -> paste tab paste tab paste tab
		p3e -> paste enter ...
		p2-5 -> paste entry b to e (b c d e)
		p2-5e -> paste entry b to e (b enter c enter d enter e enter)
	 */

	 if (Command = "p")
		{
		 if (SubStr(cmd,0) = "t")
			{
			 sendtab:=1
			 cmd:=RTrim(cmd,"t")
			}
		 if (SubStr(cmd,0) = "e")
			{
			 sendenter:=1
			 cmd:=RTrim(cmd,"e")
			}

		 if InStr(cmd,"-")
			range:=1

		 cmd:=cmdrRange(cmd)

		 Loop, parse, cmd, CSV
			{
			 if range
				{
				 OnClipboardChange("FuncOnClipboardChange", 0)
				 Clipboard:=History[A_LoopField].text
				 OnClipboardChange("FuncOnClipboardChange", 1)
				}
			 Send ^v
			 Sleep 100
			 if sendtab
				{
				 Send {tab}
				 Sleep 100
				}
			 if sendenter
				{
				 Send {enter}
				 Sleep 100
				}
			}
		 return
		}

	 /*
	 y	yank
		y5 -> delete most recent five
		ye -> delete most recent five
		yd-j -> delete entries d to j
	 */
	 if (Command = "y")
		{
		 if RegExMatch(cmd,"i)^[a-z]$") ; e.g. c delete a b c (three most recent)
			cmd:=cmdrAsc2Number(cmd)
		 if cmd is number
			{
			 Loop, % cmd
				History.RemoveAt(1)
			 return
			}
		 if InStr(cmd,"-")
			{
			 from:=StrSplit(cmd,"-").1
			 to:=StrSplit(cmd,"-").2
			 if RegExMatch(from,"i)^[a-z]$")
				from:=cmdrAsc2Number(from)
			 if RegExMatch(to,"i)^[a-z]$")
				to:=cmdrAsc2Number(to)
			 to-=from-1
			 History.RemoveAt(from,to)
			 return
			}

		}


	 /*
	 b	burst clipboard
		b\n burst lines
		b\t burst lines
		b\\ burst \
		b\word burst on word (string split)
		b? burst at char (, | whatever)
	 */

	 if (Command = "b")
		{
		 burst:=[]
		 if (command cmd = "b\n")
			{
			 Delim:="`n"
			 cmd:=""
			}
		 if (command cmd = "b\t")
			{
			 Delim:=A_Tab
			 cmd:=""
			}
		 if (command cmd = "b\\")
			{
			 Delim:="\"
			 cmd:=""
			}
		 if RegExMatch(cmd,")^.$")
			{
			 Delim:=cmd
			 cmd:=""
			}
		 if RegExMatch(cmd,")^\\.*$")
			{
			 Delim:=StrReplace(cmd,"\")
			 cmd:=""
			}
		 If (StrLen(Delim) > 1) ; word
			{
			 OnClipboardChange("FuncOnClipboardChange", 0)
			 Clipboard:=StrReplace(Clipboard,Delim,Chr(7))
			 OnClipboardChange("FuncOnClipboardChange", 1)
			 Delim:=Chr(7)
			}
		 burst:=StrSplit(clipboard,Delim)
		 MsgBox % ">" delim "<" burst.count() "`n" Burst[1]

		 Loop, % burst.count()
			{
				; History.Insert(1,{"text":ClipText,"icon": IconExe})
			 If !Reverse
				History.Insert(1,{"text": Burst[A_Index],"IconExe":""})
			 else
				History.Insert(1,{"text": Burst[burst.count()+1-A_Index],"IconExe":""})
			}
		 burst:=""
		}

	}

cmdrAsc2Number(in)
	{
	 StringLower, in, in
	 return Asc(in)-96
	}

cmdrRange(cmd)
	{
	 if InStr(cmd,"-")
		{
		 range:=1
		 from:=StrSplit(cmd,"-").1
		 to:=StrSplit(cmd,"-").2
		 cmd:=""
		 Loop, % to
			{
			 if (A_Index >= from)
				cmd .= A_Index ","
			}
		 cmd:=Rtrim(cmd,",")
		}
	 if cmd is number
		{
		 Loop, % cmd
			newcmd .= A_Index ","
		 cmd:=Rtrim(newcmd,",")
		}
	 return cmd
	}
