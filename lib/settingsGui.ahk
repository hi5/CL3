
Menu, SetupMenu, Add, Show Special       , SetupMenuHandler
Menu, SetupMenu, Add, Show Templates     , SetupMenuHandler 
Menu, SetupMenu, Add, Show Yank          , SetupMenuHandler
Menu, SetupMenu, Add, Show More history  , SetupMenuHandler
Menu, SetupMenu, Add, Show Exit          , SetupMenuHandler

for k, v in StrSplit("Show Special|Show Templates|Show Yank|Show More history|Show Exit","|")
	{
	 SetMenuCheck:=StrReplace(v, " ")
	 If (%SetMenuCheck% = 1)
	 	Menu, SetupMenu, Check, % v
	}

Gui, Settings:Destroy
Gui, Settings:New

Gui Settings:Add,  GroupBox, x5 y20 w170 h320, General hotkeys
Gui Settings:Font, cRed
Gui Settings:Add,  Text, xp+140   yp w25  gHelpHotkeys, %A_Space% [?] %A_Space%
Gui Settings:Font, cBlack

Gui Settings:Add,  Text, xp-132  yp+25                         , Show Menu (History*):
Gui Settings:Add,  Edit, xp+110 yp-3  w40 h20 vhk_menu         , %hk_menu%
Gui Settings:Add,  Text, xp-110 yp+25                          , Show Menu 2 (History):
Gui Settings:Add,  Edit, xp+110 yp-3  w40 h20 vhk_menu2        , %hk_menu2%
Gui Settings:Add,  Text, xp-110 yp+25                          , Paste Plain text:
Gui Settings:Add,  Edit, xp+110 yp-3  w40 h20 vhk_plaintext    , %hk_plaintext%
Gui Settings:Add,  Text, xp-110 yp+20                          , __________________________
Gui Settings:Add,  Text, xp     yp+25                          , Search:
Gui Settings:Add,  Edit, xp+110 yp-3  w40 h20 vhk_search       , %hk_search%
Gui Settings:Add,  Text, xp-110 yp+25                          , FiFo:
Gui Settings:Add,  Edit, xp+110 yp-3  w40 h20 vhk_fifo         , %hk_fifo%
Gui Settings:Add,  Text, xp-110 yp+25                          , ClipChain:
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
Gui Settings:Font, cRed
Gui Settings:Add,  Text, xp+70   yp w25  gHelpHotkeys   , %A_Space% [?] %A_Space%
Gui Settings:Font, cBlack

Gui Settings:Add,  Text, xp-62 yp+24                     , Show:
Gui Settings:Add,  Edit, xp+40 yp-3  w40 h20   vhk_slots, %hk_slots%

Loop, 9
	{
	 Gui Settings:Add,  Text, xp-40 yp+27                          , Slot %A_Index%:
	 Gui Settings:Add,  Edit, xp+40 yp-3  w40 h20 vhk_slot%A_Index%, % hk_slot%A_Index%
	}

Gui Settings:Add,  Text, xp-40 yp+27                  , Slot 10:
Gui Settings:Add,  Edit, xp+40 yp-3  w40 h20 vhk_slot0, % hk_slot0

Gui Settings:Add,  Text, xp-40 yp+27                          , Menu:
Gui Settings:Add,  Edit, xp+40 yp-3  w40 h20 vhk_slotsmenu    , %hk_slotsmenu%

Gui Settings:Add,  GroupBox, xp+60 y20 w130 h320                        , Other
Gui Settings:Add,  Text, xp+8 yp+24                                     , Max History:
Gui Settings:Add,  Edit, xp+70 yp-3  w40 h20 vMaxHistory Number         , %MaxHistory%
Gui Settings:Add,  Text, xp-70 yp+25                                    , Menu width:
Gui Settings:Add,  Edit, xp+70 yp-3  w40 h20 vMenuWidth Number          , %MenuWidth%
Gui Settings:Add,  Text, xp-70 yp+25                                    , More History:
Gui Settings:Add,  Edit, xp+70 yp-3  w40 h20
Gui Settings:Add,  UpDown, Range-100-300 vMoreHistory                   , %MoreHistory%
Gui Settings:Add,  Checkbox, xp-70 yp+24 vAllowDupes                    , Allow Duplicates
Gui Settings:Add,  Button, xp yp+24 h22 w110  gSetupMenu                , Setup Menu
Gui Settings:Add,  Text, xp yp+22                                       , ___________________
Gui Settings:Add,  Text, xp    yp+25                                    , Search width:
Gui Settings:Add,  Edit, xp+70 yp-3  w40 h20 vSearchWindowWidth Number  , %SearchWindowWidth%
Gui Settings:Add,  Text, xp-70 yp+30                                    , Search height:
Gui Settings:Add,  Edit, xp+70 yp-3  w40 h20 vSearchWindowHeight Number , %SearchWindowHeight%
Gui Settings:Add,  Text, xp-70 yp+20                                    , ___________________
Gui Settings:Add,  Text, xp    yp+20                                    , CyclePlugins:

Gosub, UpdateCyclePlugins
Gui Settings:Add,  Edit, xp-5  yp+15  w125 R5 vEditCyclePlugins , %EditCyclePlugins%

Gui Settings:Add,  GroupBox, x5   yp+88 w278 h55                , Exclude programs (CSV: program1.exe,prg2.exe)

Gui Settings:Add,  Edit,     xp+8 yp+20  w260 h20 vExclude      , %Exclude%

Gui Settings:Add,  GroupBox, xp+278 yp-20  w130 h55             , Folders (Dir1;Dir2)

Gui Settings:Font, cRed
Gui Settings:Add,  Text, xp+100   yp w25  gFoldersHelp   , %A_Space% [?] %A_Space%
Gui Settings:Font, cBlack

Gui Settings:Add,  Edit, xp-90 yp+20   w110 h20 vSettingsFolders HwndFldrs, %SettingsFolders%
SetEditCueBanner(Fldrs,"Default CL3 Folders")


Gui Settings:Add,  Button, x5 yp+40   w100 h25 gSettingsSave     , &Save
Gui Settings:Add,  Button, xp+158 yp  w100 h25 gSettingsDefault  , &Default
Gui Settings:Add,  Button, xp+159 yp  w100 h25 gSettingsGuiEscape, &Cancel

Gui Settings:Add,  GroupBox, xp+110 y20 w100 h412                , Special
Gui Settings:Add,  Checkbox, xp+8 yp+24 vActivateApi             , Activate API

Gui Settings:Add,  Checkbox, xp yp+25 vActivateCmdr              , ccmdr plugin
Gui Settings:Add,  Edit    , xp+20 yp+15 w60 h20 vhk_cmdr        , %hk_cmdr%

Gui Settings:Add,  Checkbox, xp-20 yp+25 vActivateNotes          , notes plugin
Gui Settings:Add,  Edit    , xp+20 yp+15 w60 h20 vhk_notes       , %hk_notes%

Gui Settings:Add,  Checkbox, xp-20 yp+25 vActivateBackup         , Auto Backup
Gui Settings:Add,  Edit    , xp+20 yp+15 w60 h20 vBackupTimer Number, %BackupTimer%

Gui Settings:Add,  Checkbox, xp-20 yp+25 vShowLines              , Show lines
LineFormat:=StrReplace(LineFormat,A_Tab,"\t")
Gui Settings:Add,  Edit    , xp+20 yp+15 w60 h20 vLineFormat     , %LineFormat%

Gui Settings:Add,  Checkbox, xp-20 yp+25 vShowTime               , Show time
Gui Settings:Add,  Edit    , xp+20 yp+15 w60 h20 vTimeFormat     , %TimeFormat%

Gui Settings:Add,  Checkbox, xp-20 yp+24 vAutoReplaceTrayTip     , AutoRepl. TT
Gui Settings:Add,  Text    , xp    yp+25                         , Clipchain HK:
Gui Settings:Add,  Edit    , xp    yp+15 w80 vhk_ClipChainPaste  , %hk_ClipChainPaste%
Gui Settings:Add,  Text    , xp    yp+25                         , Bypass AutoRepl.`npaste [1st entry]:
Gui Settings:Add,  Edit    , xp    yp+25 w80 vhk_BypassAutoReplace, %hk_BypassAutoReplace%
Gui Settings:Add,  Text    , xp    yp+25                         , Clipb. delay (ms)
Gui Settings:Font, cRed
Gui Settings:Add,  Text    , xp+80 yp gModHelp2                  , ?
Gui Settings:Font, cBlack
Gui Settings:Add,  Edit    , xp-80 yp+18 w35 Number vCopyDelay   , %CopyDelay%
Gui Settings:Add,  Edit    , xp+45 yp    w35 Number vPasteDelay  , %PasteDelay%

If AllowDupes
	GuiControl,, AllowDupes, 1
If ActivateApi
	GuiControl,, ActivateApi, 1
If ActivateNotes
	GuiControl,, ActivateNotes, 1
If ActivateCmdr
	GuiControl,, ActivateCmdr, 1
If ActivateBackup
	GuiControl,, ActivateBackup, 1
If ShowLines
	GuiControl,, ShowLines, 1
If ShowTime
	GuiControl,, ShowTime, 1
If AutoReplaceTrayTip
	GuiControl,, AutoReplaceTrayTip, 1

;Gui Settings:Add,  GroupBox, xp-8 yp+30 w100 h168                , Info
;Gui Settings:Font, s6
;Gui Settings:Add,  Text    , xp+8 yp+24, CL3

Gui Show, w545 h440, CL3 Settings - %version%
Return

SetupMenu:
Menu, SetupMenu, Show
Return

SetupMenuHandler:
for k, v in StrSplit("Show Special|Show Templates|Show Yank|Show More history|Show Exit","|")
	{
	 If (A_ThisMenuItem = v)
	 {
		SetMenuCheck:=StrReplace(A_ThisMenuItem," ")
		%SetMenuCheck%:=!%SetMenuCheck%
		;MsgBox % SetMenuCheck ":" %SetMenuCheck%
		Menu, SetupMenu, ToggleCheck, % A_ThisMenuItem
	 }
	}
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

IniWrite, %hk_menu%, %ini%   , Hotkeys, hk_menu
IniWrite, %hk_menu2%, %ini%  , Hotkeys, hk_menu2
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

IniWrite, %hk_slotsmenu%       , %ini%, Hotkeys, hk_slotsmenu

IniWrite, %MenuWidth%          , %ini%, Settings, MenuWidth
IniWrite, %MaxHistory%         , %ini%, Settings, MaxHistory
IniWrite, %MoreHistory%        , %ini%, Settings, MoreHistory
IniWrite, %AllowDupes%         , %ini%, Settings, AllowDupes
IniWrite, %SearchWindowWidth%  , %ini%, Settings, SearchWindowWidth
IniWrite, %SearchWindowHeight% , %ini%, Settings, SearchWindowHeight
IniWrite, %ActivateApi%        , %ini%, Settings, ActivateApi
IniWrite, %ActivateBackup%     , %ini%, settings, ActivateBackup
IniWrite, %BackupTimer%        , %ini%, settings, BackupTimer
IniWrite, %ShowLines%          , %ini%, Settings, ShowLines
IniWrite, %ShowTime%           , %ini%, Settings, ShowTime
IniWrite, %AutoReplaceTrayTip% , %ini%, Settings, AutoReplaceTrayTip
IniWrite, %CopyDelay%          , %ini%, Settings, CopyDelay
IniWrite, %PasteDelay%         , %ini%, Settings, PasteDelay
IniWrite, %Exclude%            , %ini%, Settings, Exclude
IniWrite, %SettingsFolders%    , %ini%, Settings, SettingsFolders
IniWrite, %ShowSpecial%        , %ini%, Settings, ShowSpecial
IniWrite, %ShowTemplates%      , %ini%, Settings, ShowTemplates
IniWrite, %ShowYank%           , %ini%, Settings, ShowYank  
IniWrite, %ShowMorehistory%    , %ini%, Settings, ShowMorehistory
IniWrite, %ShowExit%           , %ini%, Settings, ShowExit  

LineFormat:=StrReplace(LineFormat,A_Tab,"\t")
IniWrite, %LineFormat%         , %ini%, settings, LineFormat
IniWrite, %TimeFormat%         , %ini%, settings, TimeFormat

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

HelpHotkeys:
MsgBox, 32, CL3 Hotkeys Help,
(
To disable a feature/plugin, simple delete the associated hotkey(s).

Example: to disable ClipChain or Slots, remove (all) hotkey(s).

* Show menu hotkey is mandatory.

Modifiers:

#	Windows-key
^	Ctrl
+	Shift
!	Alt
< >	use RIGHT or LEFT modifier (>^ = RIGHT Control)

F1-F12	Function keys

See AutoHotkey help for further details.
)
Return


ModHelp:
MsgBox, 32, CL3 CyclePlugins Help,
(
If you want to change the default modifier from LWin to say RAlt:
Close CL3 and edit the hk_cyclemodkey key in settings.ini
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

FoldersHelp:
MsgBox, 32, CL3 Clipboard folders Help,
(
[expert setting]

By default CL3 uses two folders to store History/Plugin and Templates data.

ClipData:

`%A_ScriptDir`%\ClipData\

* AutoReplace
* ClipChain
* History
* Notes
* Slots

Templates:

`%A_ScriptDir`%\Templates\

You can change the path for one or both of these, separate them with a semi-colon (;).
To only set the Templates folder start with semi-colon `;My_Preferred_Path_to_Templates_folder\

Omit "ClipData\" and "Templates\" as those are automatically appended by CL3

The following A_ variables are permitted (e.g. `%A_ScriptDir`%)

%ahk_folders% (last one is an environment variable, use as `%A_UserProfile`%)

Tip: if you use `%A_AppData`% - do add \CL3 as in `%A_AppData`%CL3

)
Return


; https://autohotkey.com/board/topic/76540-function-seteditcuebanner-ahk-l/
SetEditCueBanner(HWND, Cue) {  ; requires AHL_L
   Static EM_SETCUEBANNER := (0x1500 + 1)
   Return DllCall("User32.dll\SendMessageW", "Ptr", HWND, "Uint", EM_SETCUEBANNER, "Ptr", True, "WStr", Cue)
}