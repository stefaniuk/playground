$EXECUTABLE = "TrueCrypt Setup 6.3a.exe"
Run($EXECUTABLE)

$WINDOW = "TrueCrypt Setup 6.3a"

; License
WinWait($WINDOW, "License")
WinActivate($WINDOW, "License")
ControlCommand($WINDOW, "", "[CLASS:Button; TEXT:I a&ccept and agree to be bound by the license terms]", "Check", "")
ControlClick($WINDOW, "", "[CLASS:Button; TEXT:&Accept]")

; Wizard Mode
WinWait($WINDOW, "Wizard Mode")
WinActivate($WINDOW, "Wizard Mode")
ControlClick($WINDOW, "", "[CLASS:Button; TEXT:&Next >]")

; Setup Options
WinWait($WINDOW, "Setup Options")
WinActivate($WINDOW, "Setup Options")
ControlCommand($WINDOW, "", "[CLASS:Create System &Restore point]", "UnCheck", "")
ControlClick($WINDOW, "", "[CLASS:Button; TEXT:&Install]")

; TrueCrypt has been successfully installed.
WinWait("TrueCrypt Setup", "TrueCrypt has been successfully installed.")
WinActivate("TrueCrypt Setup", "TrueCrypt has been successfully installed.")
ControlClick("TrueCrypt Setup", "", "[CLASS:Button; TEXT:OK]")

; If you have never used TrueCrypt before
WinWait("TrueCrypt Setup", "If you have never used TrueCrypt before")
WinActivate("TrueCrypt Setup", "If you have never used TrueCrypt before")
ControlClick("TrueCrypt Setup", "", "[CLASS:Button; TEXT:&No]")

; TrueCrypt Installed
WinWait($WINDOW, "TrueCrypt Installed")
WinActivate($WINDOW, "TrueCrypt Installed")
ControlClick("TrueCrypt Setup", "", "[CLASS:Button; TEXT:&Finish]")
