$EXECUTABLE = $CMDLINE[1] & "\Drivers\chipset\Setup.exe"
Run($EXECUTABLE)

$WINDOW = "Intel(R) Chipset Device Software"

; Welcome to the Setup Program
WinWait($WINDOW, "Welcome to the Setup Program")
WinActivate($WINDOW, "Welcome to the Setup Program")
ControlClick($WINDOW, "", "[CLASS:Button; TEXT:&Next >]")

; License Agreement
WinWait($WINDOW, "License Agreement")
WinActivate($WINDOW, "License Agreement")
ControlClick($WINDOW, "", "[CLASS:Button; TEXT:&Yes]")

; Readme File Information
WinWait($WINDOW, "Product: Intel(R) Chipset Device Software")
WinActivate($WINDOW, "Product: Intel(R) Chipset Device Software")
ControlClick($WINDOW, "", "[CLASS:Button; TEXT:&Next >]")

; Setup Progress
WinWait($WINDOW, "Setup Progress")
WinActivate($WINDOW, "Setup Progress")
ControlClick($WINDOW, "", "[CLASS:Button; TEXT:&Next]")

; Setup Is Complete
WinWait($WINDOW, "Setup Is Complete")
WinActivate($WINDOW, "Setup Is Complete")
ControlClick($WINDOW, "", "[CLASS:Button; TEXT:No, I will restart this computer later.]")
ControlClick($WINDOW, "", "[CLASS:Button; TEXT:&Finish]")
