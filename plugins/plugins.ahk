/*
Plugins for CL3

To add a plugin:
Make a file named "MyPlugins.ahk" with the following content below
(between the lines)

PluginScriptFunction.ahk: function you made that modifies
the content of the clipboard before it will be pasted.
MyPlugins.ahk will not be part of CL3 so will never be overwritten
by updates.

To add each plugin:
1. Create a script and place it in the plugins\ directory
2. edit plugins\Myplugins.ahk and add the name of script TWICE
   in the "join list" at the top and in the #include section below it as well.
   The order in which they are listed is used for the menu entries.

; -----------------------------
MyPluginlistFunc=
(join|
PluginScriptFunction.ahk
)

#include %A_ScriptDir%\plugins\PluginScriptFunction.ahk
; etc
; -----------------------------

*/

pluginlistFunc= ; shown after "My Plugins" in special menu (so second or third)
(join|
AutoReplace.ahk
ClipChain.ahk
Compact.ahk
DumpHistory.ahk
Search.ahk
Slots.ahk
Fifo.ahk
)

pluginlistClip= ; shown first in Special menu
(join|
Lower.ahk
Title.ahk
Sort.ahk
Send.ahk
LowerReplaceSpace.ahk
PasteUnwrapped.ahk
Upper.ahk
)

Gosub, SlotsInit
Gosub, ClipChainInit
Gosub, FifoInit
Gosub, AutoReplaceInit
Gosub, SortMenuSetup
Gosub, ccmdersetup
Gosub, NotesMenuSetup

;@Ahk2Exe-IgnoreBegin
#include *i %A_ScriptDir%\plugins\MyPlugins.ahk
;@Ahk2Exe-IgnoreEnd

#include %A_ScriptDir%\plugins\LowerReplaceSpace.ahk
#include %A_ScriptDir%\plugins\Lower.ahk
#include %A_ScriptDir%\plugins\Title.ahk
#include %A_ScriptDir%\plugins\Upper.ahk
#include %A_ScriptDir%\plugins\Send.ahk
#include %A_ScriptDir%\plugins\AutoReplace.ahk
#include %A_ScriptDir%\plugins\Slots.ahk
#include %A_ScriptDir%\plugins\Sort.ahk
#include %A_ScriptDir%\plugins\Search.ahk
#include %A_ScriptDir%\plugins\DumpHistory.ahk
#include %A_ScriptDir%\plugins\ClipChain.ahk	
#include %A_ScriptDir%\plugins\Compact.ahk	
#include %A_ScriptDir%\plugins\Fifo.ahk
#include %A_ScriptDir%\plugins\PasteUnwrapped.ahk
#include %A_ScriptDir%\plugins\ccmdr.ahk
#include %A_ScriptDir%\plugins\notes.ahk
