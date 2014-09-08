$EXECUTABLE = $CMDLINE[1] & "\Drivers\video\178.24_geforce_winxp_64bit_international_whql.exe"
Run($EXECUTABLE)

$WINDOW = "NVIDIA Windows XP x64 Edition Display Drivers - InstallShield Wizard"

; Location
WinWait($WINDOW, "Please enter the folder where you want these files saved.")
WinActivate($WINDOW, "Please enter the folder where you want these files saved.")
ControlClick($WINDOW, "", "[CLASS:Button; TEXT:&Next >]")

$WINDOW = "NVIDIA Windows XP x64 Edition Display Drivers"

; Welcome
WinWait($WINDOW, "Welcome to the InstallShield Wizard for NVIDIA Drivers")
WinActivate($WINDOW, "Welcome to the InstallShield Wizard for NVIDIA Drivers")
ControlClick($WINDOW, "", "[CLASS:Button; TEXT:&Next >]")

; License
WinWait($WINDOW, "License For Customer Use of NVIDIA Software")
WinActivate($WINDOW, "License For Customer Use of NVIDIA Software")
ControlClick($WINDOW, "", "[CLASS:Button; TEXT:&Yes]")

; Complete
WinWait($WINDOW, "InstallShield Wizard Complete")
WinActivate($WINDOW, "InstallShield Wizard Complete")
ControlClick($WINDOW, "", "[CLASS:Button; TEXT:No, I will restart my computer later.]")
ControlClick($WINDOW, "", "[CLASS:Button; TEXT:Finish]")
