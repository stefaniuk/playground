$EXECUTABLE = $CMDLINE[1] & "\Drivers\audio\Setup.exe"
Run($EXECUTABLE)

$WINDOW = "Realtek High Definition Audio Driver Setup (2.38) R1.73"

; Welcome
WinWait($WINDOW, "Welcome to the InstallShield Wizard for Realtek High Definition Audio Driver")
WinActivate($WINDOW, "Welcome to the InstallShield Wizard for Realtek High Definition Audio Driver")
ControlClick($WINDOW, "", "[CLASS:Button; TEXT:&Next >]")

; InstallShield Wizard Complete
WinWait($WINDOW, "InstallShield Wizard Complete")
WinActivate($WINDOW, "InstallShield Wizard Complete")
ControlClick($WINDOW, "", "[CLASS:Button; TEXT:No, I will restart my computer later.]")
ControlClick($WINDOW, "", "[CLASS:Button; TEXT:Finish]")
