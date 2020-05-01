
Gui, Settings:Destroy
Gui, Settings:New

Gui Settings:Add,  GroupBox, x5 y20 w170 h320, General hotkeys

Gui Settings:Add,  Text, xp+8  yp+25                           , Show Menu (History):
Gui Settings:Add,  Edit, xp+110 yp-3  w40 h20 vhk_menu         , %hk_menu%
Gui Settings:Add,  Text, xp-110 yp+30                          , Paste Plain text:
Gui Settings:Add,  Edit, xp+110 yp-3  w40 h20 vhk_plaintext    , %hk_plaintext%
Gui Settings:Add,  Text, xp-110 yp+20                          , __________________________
Gui Settings:Add,  Text, xp     yp+30                          , Search:
Gui Settings:Add,  Edit, xp+110 yp-3  w40 h20 vhk_search       , %hk_search%
Gui Settings:Add,  Text, xp-110 yp+30                          , FiFo:
Gui Settings:Add,  Edit, xp+110 yp-3  w40 h20 vhk_fifo         , %hk_fifo%
Gui Settings:Add,  Text, xp-110 yp+30                          , ClipChain:
Gui Settings:Add,  Edit, xp+110 yp-3  w40 h20 vhk_clipchain    , %hk_clipchain%
Gui Settings:Add,  Text, xp-110 yp+20                          , __________________________

Gui Settings:Font, cRed
Gui Settings:Add,  Text, xp     yp+20 w150  gModHelp           , Do not add modifiers below! [?]
Gui Settings:Font, cBlack

Gui Settings:Add,  Text, xp     yp+23                          , Cycle forward:
Gui Settings:Add,  Edit, xp+110 yp-3  w40 h20 vhk_cycleforward , %hk_cycleforward%
Gui Settings:Add,  Text, xp-110 yp+30                          , Cycle backward:
Gui Settings:Add,  Edit, xp+110 yp-3  w40 h20 vhk_cyclebackward, %hk_cyclebackward%
Gui Settings:Add,  Text, xp-110 yp+30                          , Cycle cancel:
Gui Settings:Add,  Edit, xp+110 yp-3  w40 h20  vhk_cyclecancel , %hk_cyclecancel%
Gui Settings:Add,  Text, xp-110 yp+30                          , Cycle plugin:
Gui Settings:Add,  Edit, xp+110 yp-3  w40 h20 vhk_cycleplugins , %hk_cycleplugins%

Gui Settings:Add,  GroupBox, xp+60 y20 w100 h320        , Slots
Gui Settings:Add,  Text, xp+8 yp+24                     , Show:
Gui Settings:Add,  Edit, xp+40 yp-3  w40 h20   vhk_slots, %hk_slots%

Loop, 9
	{
	 Gui Settings:Add,  Text, xp-40 yp+30                          , Slot %A_Index%:
	 Gui Settings:Add,  Edit, xp+40 yp-3  w40 h20 vhk_slot%A_Index%, % hk_slot%A_Index%
	}

Gui Settings:Add,  Text, xp-40 yp+30                  , Slot 10:
Gui Settings:Add,  Edit, xp+40 yp-3  w40 h20 vhk_slot0, % hk_slot0

Gui Settings:Add,  GroupBox, xp+60 y20 w130 h320                , Other
Gui Settings:Add,  Text, xp+8 yp+24                                     , Max History:
Gui Settings:Add,  Edit, xp+70 yp-3  w40 h20 vMaxHistory Number         , %MaxHistory%
Gui Settings:Add,  Text, xp-70 yp+30                                    , Menu width:
Gui Settings:Add,  Edit, xp+70 yp-3  w40 h20 vMenuWidth Number          , %MenuWidth%
Gui Settings:Add,  Text, xp-70 yp+20                                    , ___________________
Gui Settings:Add,  Text, xp    yp+30                                    , Search width:
Gui Settings:Add,  Edit, xp+70 yp-3  w40 h20 vSearchWindowWidth Number  , %SearchWindowWidth%
Gui Settings:Add,  Text, xp-70 yp+30                                    , Search height:
Gui Settings:Add,  Edit, xp+70 yp-3  w40 h20 vSearchWindowHeight Number , %SearchWindowHeight%
Gui Settings:Add,  Text, xp-70 yp+20                                    , ___________________
Gui Settings:Add,  Text, xp    yp+30                                    , CyclePlugins:

Gosub, UpdateCyclePlugins
Gui Settings:Add,  Edit, xp-5  yp+15  w125 R9 vEditCyclePlugins , %EditCyclePlugins%

Gui Settings:Add,  Button, x5 yp+140  w100 h25 gSettingsSave     , &Save
Gui Settings:Add,  Button, xp+158 yp  w100 h25 gSettingsDefault  , &Default
Gui Settings:Add,  Button, xp+159 yp  w100 h25 gSettingsGuiEscape, &Cancel

Gui Settings:Add,  GroupBox, xp+110 y20 w100 h352                , Special
Gui Settings:Add,  Checkbox, xp+8 yp+24 vActivateApi             , Activate API
Gui Settings:Add,  Checkbox, xp yp+30 vActivateCmdr              , ccmdr plugin
Gui Settings:Add,  Edit    , xp+20 yp+20 w60 h20 vhk_cmdr        , %hk_cmdr%
Gui Settings:Add,  Checkbox, xp-20 yp+30 vActivateNotes          , notes plugin
Gui Settings:Add,  Edit    , xp+20 yp+20 w60 h20 vhk_notes       , %hk_notes%
Gui Settings:Add,  Checkbox, xp-20 yp+30 vShowLines              , Show lines
Gui Settings:Add,  Text    , xp    yp+30                         , Clipchain HK:
Gui Settings:Add,  Edit    , xp    yp+20 w80 vhk_ClipChainPaste  , %hk_ClipChainPaste%
Gui Settings:Add,  Text    , xp    yp+30                         , Bypass AutoRepl.`npaste [1st entry]:
Gui Settings:Add,  Edit    , xp    yp+30 w80 vhk_BypassAutoReplace, %hk_BypassAutoReplace%
Gui Settings:Add,  Text    , xp    yp+30                         , Clipb. delay (ms)
Gui Settings:Font, cRed
Gui Settings:Add,  Text    , xp+80 yp gModHelp2                  , ?
Gui Settings:Font, cBlack
Gui Settings:Add,  Edit    , xp-80 yp+20 w35 Number vCopyDelay   , %CopyDelay%
Gui Settings:Add,  Edit    , xp+45 yp    w35 Number vPasteDelay  , %PasteDelay%


If ActivateApi
	GuiControl,, ActivateApi, 1
If ActivateNotes
	GuiControl,, ActivateNotes, 1
If ActivateCmdr
	GuiControl,, ActivateCmdr, 1
If ShowLines
	GuiControl,, ShowLines, 1

;Gui Settings:Add,  GroupBox, xp-8 yp+30 w100 h168                , Info
;Gui Settings:Font, s6
;Gui Settings:Add,  Text    , xp+8 yp+24, CL3 

Gui Show, w545 h380, CL3 Settings - %version%
Return

SettingsGuiEscape:
SettingsGuiClose:
Gui Settings:Destroy
Return

SettingsDefault:
Gui Settings:Default

for k, v in Settings_Hotkeys
	GuiControl, , %k%, %v%
for k, v in Settings_Settings
	GuiControl, ,  %k%, %v%

hk_cyclemodkey:=Settings_Hotkeys.hk_cyclemodkey

EditCyclePlugins:=Trim(StrReplace(Settings_Plugins.Plugins,",","`n")," `n")
GuiControl, , EditCyclePlugins, %EditCyclePlugins%

Return

SettingsSave:
Gui, Settings:Submit, Destroy
; IniWrite, Value, Filename, Section, Key

CyclePlugins:=Trim(StrReplace(EditCyclePlugins,"`n",","),", ")
IniWrite, %CyclePlugins%       , %ini%, Plugins, CyclePlugins

IniWrite, %hk_menu%, %ini%, Hotkeys, hk_menu
IniWrite, %hk_plaintext%     , %ini%, Hotkeys, hk_plaintext
IniWrite, %hk_slots%         , %ini%, Hotkeys, hk_slots
IniWrite, %hk_clipchain%     , %ini%, Hotkeys, hk_clipchain
IniWrite, %hk_clipchainpaste%, %ini%, Hotkeys, hk_clipchainpaste
IniWrite, %hk_fifo%          , %ini%, Hotkeys, hk_fifo
IniWrite, %hk_search%        , %ini%, Hotkeys, hk_search
IniWrite, %hk_cyclemodkey%   , %ini%, Hotkeys, hk_cyclemodkey
IniWrite, %hk_cyclebackward% , %ini%, Hotkeys, hk_cyclebackward
IniWrite, %hk_cycleforward%  , %ini%, Hotkeys, hk_cycleforward
IniWrite, %hk_cycleplugins%  , %ini%, Hotkeys, hk_cycleplugins
IniWrite, %hk_cyclecancel%   , %ini%, Hotkeys, hk_cyclecancel
IniWrite, %hk_notes%         , %ini%, Hotkeys, hk_notes
IniWrite, %hk_cmdr%          , %ini%, Hotkeys, hk_cmdr
IniWrite, %hk_BypassAutoReplace%, %ini%, Hotkeys, hk_BypassAutoReplace

Loop, 9
	IniWrite, % hk_slot%A_Index%  , %ini%, Hotkeys, hk_slot%A_Index%
IniWrite, %hk_slot0%, %ini%, Hotkeys, hk_slot0

IniWrite, %MaxHistory%         , %ini%, Settings, MaxHistory
IniWrite, %MenuWidth%          , %ini%, Settings, MenuWidth
IniWrite, %SearchWindowWidth%  , %ini%, Settings, SearchWindowWidth
IniWrite, %SearchWindowHeight% , %ini%, Settings, SearchWindowHeight
IniWrite, %ActivateApi%        , %ini%, Settings, ActivateApi
IniWrite, %ShowLines%          , %ini%, Settings, ShowLines
IniWrite, %CopyDelay%          , %ini%, Settings, CopyDelay
IniWrite, %PasteDelay%         , %ini%, Settings, PasteDelay

IniWrite, %ActivateNotes% , %ini%, Plugins, ActivateNotes
IniWrite, %ActivateCmdr%  , %ini%, Plugins, ActivateCmdr

Sleep 100
Reload ; if hotkey(s) have changed we'd need to deactivate/reactive all hotkeys, reloading saves us the trouble

Return

UpdateCyclePlugins:
EditCyclePlugins:=""
for k, v in CyclePlugins
	if (v = "<none>")
		continue
	else
		EditCyclePlugins .= v "`n"
Return

ModHelp:
MsgBox, 32, CL3 CyclePlugins Help,
(
If you want to change the default modifier from LWin to say RAlt:
Close CL3 and the hk_cyclemodkey key edit in settings.ini
(see [Hotkeys] section)

Examples:

hk_cyclemodkey=RAlt
hk_cyclemodkey=LCtrl

Using "Default" to restore the default settings will also reset hk_cyclemodkey.
)
Return

ModHelp2:
MsgBox, 32, CL3 Clipboard delay Help,
(
Time in milliseconds to wait before adding a Copy of a new clipboard entry to the CL3 history. (left edit control)
This may resolve some conflicts when other programs or scripts access the clipboard.
Increasing this value may work around this issue.

A value for a Paste Delay (right edit control) can also be set.
)
Return
