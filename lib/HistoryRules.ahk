/*

HistoryRules() to read rules from \HistoryRules.ini to allow CL3 to filter
clipboard content before adding it to history, allowing or skipping text

Version           : 1.0
CL3 version       : 1.101

History:
- 1.0 initial version

*/

HistoryRules()
	{
	 Global
	 local Global,Active,Copy,Filter,SectionNames
	 HistoryRules:=[]
	 IniRead, SectionNames, %A_ScriptDir%\HistoryRules.ini
	 If (SectionNames = "")
	 	Return
	 
	 Loop, parse, SectionNames, `n, `r
		{
		 If (A_LoopField = "Setting")
			{
			 IniRead, Global, %A_ScriptDir%\HistoryRules.ini, %A_LoopField%, Global
			 If !Global ; HistoryRules is disabled so no need to try and read the rules
				break
			 IniRead, Copy, %A_ScriptDir%\HistoryRules.ini, %A_LoopField%, Copy
				HistoryRules["Copy"]:=Copy
			}
		 IniRead, Active, %A_ScriptDir%\HistoryRules.ini, %A_LoopField%, Active
		 If (Active = "ERROR") or (Active = "")
			continue
		 IniRead, Filter, %A_ScriptDir%\HistoryRules.ini, %A_LoopField%, filter
		 If (Filter = "ERROR") or (Filter = "")
			continue
		 HistoryRules[A_LoopField,"Active"]:=Active
		 HistoryRules[A_LoopField,"Filter"]:=Filter
		}
	}
