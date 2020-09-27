Settings()
	{
	 global
	 local SettingsOutputVar
	 CyclePlugins:=[]
	 ini:=A_ScriptDir "\settings.ini"
	 ; CyclePlugins
	 IniRead, SettingsOutputVar, %ini%, plugins, CyclePlugins
	 If (SettingsOutputVar = "ERROR")
		{
		 IniWrite, Title`,Lower`,Upper`,LowerReplaceSpace, %ini%, plugins, CyclePlugins
		 SettingsOutputVar=Title,Lower,Upper,LowerReplaceSpace
		}
	 Loop, parse, SettingsOutputVar, CSV
		CyclePlugins.push(A_LoopField)
	 CyclePlugins[0]:="<none>"
	 Stats_Create()
	 IniRead, MaxHistory         , %ini%, settings, MaxHistory, 150
	 IniRead, MenuWidth          , %ini%, settings, MenuWidth, 40
	 IniRead, SearchWindowWidth  , %ini%, settings, SearchWindowWidth, 595
	 IniRead, SearchWindowHeight , %ini%, settings, SearchWindowHeight, 300
	 IniRead, ShowLines          , %ini%, settings, ShowLines, 0
	 IniRead, AutoReplaceTrayTip , %ini%, settings, AutoReplaceTrayTip, 0
	 IniRead, CopyDelay          , %ini%, settings, CopyDelay, 0
	 IniRead, PasteDelay         , %ini%, settings, PasteDelay, 50
	 IniRead, ActivateApi        , %ini%, settings, ActivateApi, 0
	 IniRead, ActivateBackup     , %ini%, settings, ActivateBackup, 0
	 IniRead, BackupTimer        , %ini%, settings, BackupTimer, 10
	 IniRead, Exclude            , %ini%, settings, Exclude, 0
	 IniRead, LineFormat         , %ini%, settings, LineFormat, \t(\l line),\t(\l lines)
	 IniRead, ActivateCmdr       , %ini%, plugins , ActivateCmdr, 0
	 IniRead, ActivateNotes      , %ini%, plugins , ActivateNotes, 0
	 If (Exclude = 0) or (Exclude = "Error")
		Exclude:=""
	 StringLower, Exclude, Exclude

	 LineTextFormat:=StrSplit(StrReplace(LineFormat,"\t",A_Tab),",")

	 SettingsObj:={"MaxHistory":MaxHistory,"ActivateCmdr":ActivateCmdr}
	 If (XA_Load(A_ScriptDir "\stats.xml") = 1) ; the name of the variable containing the array is returned OR the value 1 in case of error
		{
		 MsgBox, 16, Stats, Stats.xml seems to be corrupt, starting new empty Stats.
		 FileDelete, %A_ScriptDir%\Stats.xml
		 Stats_Create()
		}
	 Settings_Default()
	}

Settings_Default()
	{
	 global
 	 Settings_Plugins:={ Plugins : "Title`,Lower`,Upper`,LowerReplaceSpace" }
	 Settings_Hotkeys:={ hk_menu         :"^!v"
		, hk_plaintext     :"^+v"
		, hk_slots         :"^#F12"
		, hk_clipchain     :"^#F11"
		, hk_clipchainpaste:"^v"
		, hk_fifo          :"^#F10"
		, hk_search        :"^#h"
		, hk_cyclemodkey   :"LWin"
		, hk_cyclebackward :"v"
		, hk_cycleforward  :"c"
		, hk_cycleplugins  :"f"
		, hk_cyclecancel   :"x" 
		, hk_slot1         :">^1"
		, hk_slot2         :">^2"
		, hk_slot3         :">^3"
		, hk_slot4         :">^4"
		, hk_slot5         :">^5"
		, hk_slot6         :">^6"
		, hk_slot7         :">^7"
		, hk_slot8         :">^8"
		, hk_slot9         :">^9"
		, hk_slot0         :">^0"
		, hk_notes         :"#n"
		, hk_BypassAutoReplace :""
		, hk_cmdr          :"#j" }
	 Settings_Settings:={ MaxHistory :"150"
		, MenuWidth         : 40
		, SearchWindowWidth : 595
		, SearchWindowHeight: 300
		, ActivateApi       : 0
		, ShowLines         : 1
		, AutoReplaceTrayTip: 0
		, CopyDelay         : 0 
		, PasteDelay        : 50 
		, Exclude           : ""
		, LineFormat        : "\t(\l line),\t(\l lines)" }

	}
	
Stats_Create()
	{
	 global stats
	 IfNotExist, %A_ScriptDir%\stats.xml
		{
		 stats:={}
		 stats.cyclepaste:=0
		 stats.cycleplugins:=0
		 stats.menu:=0
		 stats.templates:=0
		 stats.slots:=0
		 stats.clipchain:=0
		 stats.search:=0
		 stats.edit:=0
		 stats.fifo:=0
		 stats.templates:=0
		 stats.copieditems:=0
		 XA_Save("stats",A_ScriptDir "\stats.xml")
		}
	}

Settings_Hotkeys()
	{
	 global
	 local ini,index,keylist
	 ini:=A_ScriptDir "\settings.ini"

	 IniRead, hk_menu          , %ini%, Hotkeys, hk_menu          ,^!v
	 IniRead, hk_plaintext     , %ini%, Hotkeys, hk_plaintext     ,^+v
	 IniRead, hk_slots         , %ini%, Hotkeys, hk_slots         ,^#F12
	 IniRead, hk_clipchain     , %ini%, Hotkeys, hk_clipchain     ,^#F11
	 IniRead, hk_clipchainpaste, %ini%, Hotkeys, hk_clipchainpaste,^v
	 IniRead, hk_fifo          , %ini%, Hotkeys, hk_fifo          ,^#F10
	 IniRead, hk_search        , %ini%, Hotkeys, hk_search        ,^#h
	 IniRead, hk_cyclemodkey   , %ini%, Hotkeys, hk_cyclemodkey   ,LWin
	 IniRead, hk_cyclebackward , %ini%, Hotkeys, hk_cyclebackward ,v
	 IniRead, hk_cycleforward  , %ini%, Hotkeys, hk_cycleforward  ,c
	 IniRead, hk_cycleplugins  , %ini%, Hotkeys, hk_cycleplugins  ,f
	 IniRead, hk_cyclecancel   , %ini%, Hotkeys, hk_cyclecancel   ,x
	 IniRead, hk_notes         , %ini%, Hotkeys, hk_notes         ,#n
	 IniRead, hk_cmdr          , %ini%, Hotkeys, hk_cmdr          ,#j
	 IniRead, hk_BypassAutoReplace, %ini%, Hotkeys, hk_BypassAutoReplace
	 If (hk_BypassAutoReplace = "ERROR")
	 	hk_BypassAutoReplace:=""

	 Loop, 10
		{
		 Index:=A_Index-1
		 IniRead, hk_slot%index%, %ini%, Hotkeys, hk_slot%index%, >^%index%
		 Hotkey, % hk_slot%index%, hk_slotpaste
		}

	 Hotkey, %hk_menu%             , hk_menu
	 Hotkey, %hk_plaintext%        , hk_plaintext
	 Hotkey, %hk_clipchain%        , hk_clipchain
	 If (hk_BypassAutoReplace <> "")
		 Hotkey, %hk_BypassAutoReplace%, hk_BypassAutoReplace

	 if (hk_clipchainpaste = "^v")
		Hotkey, $%hk_clipchainpaste%, hk_clipchainpaste_defaultpaste

	 Hotkey, If, ClipChainActive()
	 Hotkey, $%hk_clipchainpaste%, ClipChainPasteDoubleClick
	 Hotkey, If

	 Hotkey, %hk_fifo%             , hk_fifo
	 Hotkey, %hk_slots%            , hk_slots
	 Hotkey, %hk_search%           , hk_search
	 Hotkey, %hk_cyclemodkey% & %hk_cyclebackward%   , hk_cyclebackward
	 Hotkey, %hk_cyclemodkey% & %hk_cyclebackward% up, hk_cyclebackward_up
	 Hotkey, %hk_cyclemodkey% & %hk_cycleforward%    , hk_cycleforward
	 Hotkey, %hk_cyclemodkey% & %hk_cycleforward% up , hk_cycleforward_up
	 Hotkey, %hk_cyclemodkey% & %hk_cycleplugins%    , hk_cycleplugins
	 Hotkey, %hk_cyclemodkey% & %hk_cycleplugins% up , hk_cycleplugins_up
	 Hotkey, %hk_cyclemodkey% & %hk_cyclecancel%     , hk_cyclecancel
	 Hotkey, %hk_cmdr%                               , hk_cmdr
	 Hotkey, %hk_notes%                              , hk_notes
	 if !ActivateCmdr
		Hotkey, %hk_cmdr%, off
	 if !ActivateNotes
		Hotkey, %hk_notes%, off
	}

Settings_menu:
#Include %A_ScriptDir%\lib\SettingsGui.ahk

