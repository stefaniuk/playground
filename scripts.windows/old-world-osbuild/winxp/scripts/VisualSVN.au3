$EXECUTABLE = "msiexec /i VisualSVN-Server-2.1.2.msi"
Run($EXECUTABLE)

$WINDOW = "VisualSVN Server 2.1.2 Setup"

; Welcome
WinWait($WINDOW, "Welcome to the VisualSVN Server 2.1.2 Setup Wizard")
WinActivate($WINDOW, "Welcome to the VisualSVN Server 2.1.2 Setup Wizard")
ControlClick($WINDOW, "", "[CLASS:Button; TEXT:&Next]")

; License
WinWait($WINDOW, "License Agreement for VisualSVN Server")
WinActivate($WINDOW, "License Agreement for VisualSVN Server")
ControlCommand($WINDOW, "", "[CLASS:Button; TEXT:I &accept the terms in the License Agreement]", "Check", "")
ControlClick($WINDOW, "", "[CLASS:Button; TEXT:&Next]")

; Select Components
WinWait($WINDOW, "Select Components")
WinActivate($WINDOW, "Select Components")
ControlClick($WINDOW, "", "[CLASS:Button; TEXT:&Next]")

; Custom Setup
WinWait($WINDOW, "Custom Setup")
WinActivate($WINDOW, "Custom Setup")
ControlSetText($WINDOW, "", "RichEdit20W2", $CMDLINE[1])
ControlSetText($WINDOW, "", "Edit2", $CMDLINE[2])
ControlClick($WINDOW, "", "[CLASS:Button; TEXT:&Next]")

; Ready to Install
WinWait($WINDOW, "Ready to Install")
WinActivate($WINDOW, "Ready to Install")
ControlClick($WINDOW, "", "[CLASS:Button; TEXT:&Install]")

; Completing
WinWait($WINDOW, "Completing the VisualSVN Server 2.1.2 Setup Wizard")
WinActivate($WINDOW, "Completing the VisualSVN Server 2.1.2 Setup Wizard")
ControlCommand($WINDOW, "", "[CLASS:Button; TEXT:&Start VisualSVN Server Manager]", "UnCheck", "")
ControlClick($WINDOW, "", "[CLASS:Button; TEXT:&Finish]")
