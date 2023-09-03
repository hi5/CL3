/*
Basic update routine for compiled script
*/

update(v)
    {
     whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
     whr.Open("GET", "https://api.github.com/repos/hi5/cl3/releases/latest", true)
     whr.Send()
     ; Using 'true' above and the call below allows the script to remain responsive.
     whr.WaitForResponse()
     ; "tag_name":"v1.00"
     text:=whr.ResponseText
     RegExMatch(text,"U)\x22tag_name\x22:\x22\K(.*)\x22",version)
     ; MsgBox % v ":" version1 ":" version
     If (v <> version1) and (version <> "")
         {
          MsgBox, 68, New version of CL3, A new version seems to be available.`nVisit website to download it?`n`n(See releases/assets on Github)
          IfMsgBox, No
             Return
          Run, https://github.com/hi5/CL3/releases    
          Return
         }
     OSDTIP_Pop("CL3: No Updates", "No update available it seems", -1000,"W130 H60 U1")
    }