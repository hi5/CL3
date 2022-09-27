/*

Plugin            : Sort()
Purpose           : Sort current clipboard
Version           : 1.0
CL3 version       : 1.9.4

History:
- 1.0 initial version

*/

Sort(Text, options="")	{
	 Sort text, %options%
	 return text
	}

SortMenuSetup: ; label we jump to from Plugins.ahk
               ; prepare an object for the menu which we can easily reuse for checking which 
               ; option we choose in the handler. Name has to be 'PLUGIN'MENU (sortmenu) as we use that 
               ; to check if we have an object to insert a submenu while parsing the plugins
SortMenu:={ "a" : "Standard (new line)|"
	, "b" : "R - Reverse (new line)|R"
	, "c" : "N - Numerical (new line)|N"
	, "d" : "NR - Numerical`, reverse (new line)|NR"
	, "e" : "U - Unique`, remove duplicates (new line)|U"
	, "f" : "Set Delimeter and other options|" }

SortHelpText=
(join`n
C: Case sensitive	CL: Case insensitive	Dx: delimiter character
N: Numeric sort	Pn: Character position n	R: Reverse order
Random: random 	U: Unique		\: Substring last backslash
)

For k, v in SortMenu
	Menu, SortMenu, Add, % "&" k ". " StrSplit(v,"|").1, SortMenuHandler

Return

SortMenuHandler:
SortMenuItem:=A_ThisMenuItem
for k, v in SortMenu ; here we can re-use the menu object
	If (SortMenuItem = "&" k ". " StrSplit(v,"|").1)
		If !InStr(v,"Set Delimiter and other options")
			ClipText:=Sort(History[1].text,StrSplit(v,"|").2)
		else
			{
			 InputBox, SortOptions, Sort options, %SortHelpText%, , 500, 170
			 if ErrorLevel
				Return
			 ClipText:=Sort(History[1].text,SortOptions)
			}
Gosub, ClipboardHandler
Return
