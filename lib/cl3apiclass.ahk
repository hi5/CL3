/*

class CL3API

API Class for CL3 to access and modify Clipboard history from other scripts
using ObjRegisterActive() by Lexikos @ https://www.autohotkey.com/boards/viewtopic.php?t=6148

We use JSON Dump/Load to pass on strings from-to CL3 to client script.
Code by cocobelgica @ https://github.com/cocobelgica/AutoHotkey-JSON

Version           : 1.0
CL3 version       : 1.9.4

History:
- 1.0 initial version

*/

class CL3API
	{
	 Upper(Data)
		{
		 for k, v in jxon_load(data)
			History[v].text:=Upper(History[v].text)
		 return 1
		}

	 Lower(Data)
		{
		 for k, v in jxon_load(data)
			History[v].text:=Lower(History[v].text)
		 return 1
		}

	 Title(Data)
		{
		 for k, v in jxon_load(data)
			History[v].text:=Title(History[v].text)
		 return 1
		}

	 Chain(Data)
		{
		 ClipChainData:=[]
		 for k, v in jxon_load(data)
			ClipChainData.Push(v)
		 Gosub, ClipChainListview
		 return 1
		}

	 ChainInsertAt(Index,Data)
		{
		 ClipChainData.InsertAt(Index,Data)
		 Gosub, ClipChainListview
		 return 1
		}

	 ChainRemove(Index)
		{
	 	 ClipChainData.Remove(Index)
		 Gosub, ClipChainListview
		 return 1
		}

	 Slot(SlotID,Data)
		{
		 if (SlotID = 10)
				SlotID:=0
		 if SlotID between 0 and 9
			{
			 Slots[SlotID]:=Data
			 GuiControl, Slots:Text, Slot%SlotID%, % Data ; update gui which we already setup in the Slots plugins
			}
		 return 1
		}

	 Burst(Data,reverse=0)
		{
		 Loop, % Data.count()
			{
			 If !Reverse
				{
				 StrReplace(Data[A_Index],"`n","`n",Count)
				 History.Insert(1,{"text": Data[A_Index],"IconExe":"","lines":count+1})
				}
			 else
				{
				 StrReplace(Data[A_Index],"`n","`n",Count)
				 History.Insert(1,{"text": Data[Data.count()+1-A_Index],"IconExe":"","lines":count+1})
				}
			}
		 return 1
		}

	 GetSetting(Data)
		{
		 return SettingsObj[data]
		}

	 Fifo(Data)
		{
		 FifoApi(data)
		 Gosub, FifoActiveMenu
		 return 1
		} 

	 Paste(Data,key="")
		{
		 for k, v in jxon_load(data)
			{
			 clipboard:=History[v].text
			 PasteIt()
			 Sleep 100
			 if key
				Send %key%
		 	}
		 return
		}

	 Get(Data)
		{
		 tmpoutput:=[]
		 for k, v in jxon_load(data)
			tmpoutput.push(History[v].text)
	;	 cl3api.Message("CL3 GET")	
		 return jxon_dump(tmpoutput)
		}

	 InsertAt(Idx,Data)
		{
		 StrReplace(Data,"`n","`n",Count)
		 History.InsertAt(Idx,{"text":Data,"IconExe":"","lines":count+1})
		 return 1
		}

	 Remove(Data)
		{
		 for k, v in jxon_load(data)
			{
			 History.Remove(k)
			}
		 return 1
		}

	 Search(GetText,results="-1")
		{
		 tmpoutput:=[]
		 re:="iUms)" GetText
		 if InStr(GetText,A_Space) ; prepare regular expression to ensure search is done independent on the position of the words
			re:="iUms)(?=.*" RegExReplace(GetText,"iUms)(.*)\s","$1)(?=.*") ")"

		 for k, v in History
			{
			 if RegExMatch(v.text,re) 
				tmpoutput.push(History[k].text)
			 if (tmpoutput.count() = results)
				break
			}
		 return jxon_dump(tmpoutput)
		}

	 SearchIdx(GetText,results="-1")
		{
		 tmpoutput:=[]
		 re:="iUms)" GetText
		 if InStr(GetText,A_Space) ; prepare regular expression to ensure search is done independent on the position of the words
			re:="iUms)(?=.*" RegExReplace(GetText,"iUms)(.*)\s","$1)(?=.*") ")"

		 for k, v in History
			{
			 if RegExMatch(v.text,re) 
				tmpoutput.push(k)
			 if (tmpoutput.count() = results)
				break
			}
		 return jxon_dump(tmpoutput)
		}

	}
