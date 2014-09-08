$EXECUTABLE = $CMDLINE[1] & "\Drivers\lan\setup.exe"
Run($EXECUTABLE)

$WINDOW = "REALTEK GbE & FE Ethernet PCI NIC Driver - InstallShield Wizard"

; Welcome
WinWait($WINDOW, "Welcome to the InstallShield Wizard for REALTEK GbE & FE Ethernet PCI NIC Driver")
WinActivate($WINDOW, "Welcome to the InstallShield Wizard for REALTEK GbE & FE Ethernet PCI NIC Driver")
ControlClick($WINDOW, "", "[CLASS:Button; TEXT:&Next >]")

; Ready to Install the Program
WinWait($WINDOW, "Ready to Install the Program")
WinActivate($WINDOW, "Ready to Install the Program")
ControlClick($WINDOW, "", "[CLASS:Button; TEXT:&Install]")

; InstallShield Wizard Complete
WinWait($WINDOW, "InstallShield Wizard Complete")
WinActivate($WINDOW, "InstallShield Wizard Complete")
ControlClick($WINDOW, "", "[CLASS:Button; TEXT:Finish]")
