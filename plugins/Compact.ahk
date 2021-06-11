/*

Plugin            : Compact history
Purpose           : Parse history and remove entries over certain size
Version           : 1.1
CL3 version       : 1.6

History:
- v1.1 adding lines and crc to compacted history as well

*/

Compact:

Gui, Compact:Destroy
Gui, Compact:Add, Text, x5 y8 w220 h15, Compact should remove all entries over:
Gui, Compact:Font,cgray
Gui, Compact:Add, Text, x5 yp+20 w100 h15, StrLen (in K=1000)
Gui, Compact:Font,
Gui, Compact:Add, ComboBox, xp+110 yp-3 w100 R10 vChoice, 5K|10K|20K|30K|40K|50K|60K|70K|80K|90K|100K
Gui, Compact:Add, Text, x5 yp+30 w220, and/or Maximum entries in History: 
Gui, Compact:Font,cgray
Gui, Compact:Add, Text, x5 yp+20 w110, % "Current entries: " History.MaxIndex() 
Gui, Compact:Font,
Gui, Compact:Add, Edit, x115 yp-3 w100 number vChoiceMax, 
Gui, Compact:Add, Button, w100 x5 yp+30               gCompactCancel, Cancel ; so we can easily press enter
Gui, Compact:Add, Button, w100 xp+110 yp default gCompactChoice, OK ; so we can easily press enter
Gui, Compact:Show,w220,CL3Compact
Return

CompactChoice:
ChoiceMax:=""
Choice:=""
Gui, Compact:Submit, Destroy
if (ChoiceMax <> "")
	{
	 newhistory:=[]
	 for k, v in History
		{
		 if (A_Index <= ChoiceMax)
			newhistory.push({"text":v.text,"icon":v.icon,"lines":v.lines,"crc":v.crc})
		}
	 History:=newhistory
	 newhistory:=[]	 
	}
if (Choice <> "")
	{
	 Choice:=1000*RegExReplace(Choice,"\D")
	 if Choice is number
		{
		 newhistory:=[]
		 for k, v in History
			{
			 if (StrLen(check) < Choice)
				newhistory.push({"text":v.text,"icon":v.icon,"lines":v.lines,"crc":v.crc})
			}
		 History:=newhistory
		 newhistory:=[]
		}
	} 
TrayTip, CL3, History compated, 1, 17
Return

CompactCancel:
Gui, Compact:Submit, Destroy
Return