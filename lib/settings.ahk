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
	}