/*
Plugins for CL3

To add a plugin:

1. Create a script and place it in the plugins\ directory
2. edit plugins\plugins.ahk and add the name of script TWICE
   in the "join list" at the top and in the #include section below it as well.
   The order in which they are listed is used for the menu entries

*/

pluginlist=
(join|
LowerReplaceSpace.ahk
Lower.ahk
Title.ahk
Upper.ahk
Send.ahk
Search.ahk
Slots.ahk
)

#include %A_ScriptDir%\plugins\LowerReplaceSpace.ahk
#include %A_ScriptDir%\plugins\Lower.ahk
#include %A_ScriptDir%\plugins\Title.ahk
#include %A_ScriptDir%\plugins\Upper.ahk
#include %A_ScriptDir%\plugins\Send.ahk

; -[ treated as special in menu (gosub hotkey not func) ]-
#include %A_ScriptDir%\plugins\Slots.ahk
	Gosub, SlotsInit
#include %A_ScriptDir%\plugins\Search.ahk
