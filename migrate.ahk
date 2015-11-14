/*
CL3 xml migrate script, you only need to run this (once) when upgrading
from a version prior to v1.5
*/
SetWorkingDir, %A_ScriptDir%
DetectHiddenWindows, On
WinClose, %A_ScriptDir%\cl3.ahk
FileCreateDir, ClipData\History
FileCreateDir, ClipData\Slots
FileCreateDir, ClipData\AutoReplace
FileCreateDir, ClipData\ClipChain

xml=<?xml version="1.0" encoding="UTF-8"?>
FileRead, file, history.xml

Loop, *.xml, 0, 0
	{
     FileRead, File, %A_LoopFileName%
     StringReplace, file, file, `r`n,,All
     StringReplace, file, file, `n,,All
     StringReplace, file, file, `r,,All
     If InStr(File,xml "<History>")
     	FileMove, %A_LoopFileName%, ClipData\History\%A_LoopFileName%, 1
     If InStr(File,xml "<Slots>")
     	FileMove, %A_LoopFileName%, ClipData\Slots\%A_LoopFileName%, 1
     If InStr(File,xml "<AutoReplace>")
     	FileMove, %A_LoopFileName%, ClipData\AutoReplace\%A_LoopFileName%, 1
     If InStr(File,xml "<ClipChainData>")
     	FileMove, %A_LoopFileName%, ClipData\ClipChain\%A_LoopFileName%, 1
	 file:=""
	}

MsgBox Done!