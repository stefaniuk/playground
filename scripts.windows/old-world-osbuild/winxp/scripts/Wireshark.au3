$EXECUTABLE = "wireshark-win64-1.2.8.exe"
Run($EXECUTABLE)

$WINDOW = "Wireshark 1.2.8 (64-bit) Setup"

; Welcome
WinWait($WINDOW, "Welcome to the Wireshark")
WinActivate($WINDOW, "Welcome to the Wireshark")
ControlClick($WINDOW, "", "[CLASS:Button; TEXT:&Next >]")

; License
WinWait($WINDOW, "License Agreement")
WinActivate($WINDOW, "License Agreement")
ControlClick($WINDOW, "", "[CLASS:Button; TEXT:I &Agree]")

; Components
WinWait($WINDOW, "Choose Components")
WinActivate($WINDOW, "Choose Components")
ControlClick($WINDOW, "", "[CLASS:Button; TEXT:&Next >]")

; Additional Tasks
WinWait($WINDOW, "Select Additional Tasks")
WinActivate($WINDOW, "Select Additional Tasks")
ControlCommand($WINDOW, "", "[CLASS:Button; TEXT:Associate trace file extensions to Wireshark (5vw, acp, apc, atc, bfr,]", "UnCheck", "")
ControlClick($WINDOW, "", "[CLASS:Button; TEXT:&Next >]")

; Location
WinWait($WINDOW, "Choose Install Location")
WinActivate($WINDOW, "Choose Install Location")
ControlClick($WINDOW, "", "[CLASS:Button; TEXT:&Next >]")

; WinPcap
WinWait($WINDOW, "Install WinPcap?")
WinActivate($WINDOW, "Install WinPcap?")
ControlClick($WINDOW, "", "[CLASS:Button; TEXT:&Install]")

$WINDOW_WINPCAP = "WinPcap 4.1.1 Setup"

; Installer
WinWait($WINDOW_WINPCAP, "WinPcap 4.1.1 Installer")
WinActivate($WINDOW_WINPCAP, "WinPcap 4.1.1 Installer")
ControlClick($WINDOW_WINPCAP, "", "[CLASS:Button; TEXT:&Next >]")

; Welcome
WinWait($WINDOW_WINPCAP, "Welcome to the WinPcap")
WinActivate($WINDOW_WINPCAP, "Welcome to the WinPcap")
ControlClick($WINDOW_WINPCAP, "", "[CLASS:Button; TEXT:&Next >]")

; License
WinWait($WINDOW_WINPCAP, "License Agreement")
WinActivate($WINDOW_WINPCAP, "License Agreement")
ControlClick($WINDOW_WINPCAP, "", "[CLASS:Button; TEXT:I &Agree]")

; Options
WinWait($WINDOW_WINPCAP, "Installation options")
WinActivate($WINDOW_WINPCAP, "Installation options")
ControlClick($WINDOW_WINPCAP, "", "[CLASS:Button; TEXT:&Install]")

; WinPcap - Complete
WinWait($WINDOW_WINPCAP, "Completing the WinPcap 4.1.1 Setup Wizard")
WinActivate($WINDOW_WINPCAP, "Completing the WinPcap 4.1.1 Setup Wizard")
ControlClick($WINDOW_WINPCAP, "", "[CLASS:Button; TEXT:&Finish]")

; Wireshark - Complete
WinWait($WINDOW, "Installation Complete")
WinActivate($WINDOW, "Installation Complete")
ControlClick($WINDOW, "", "[CLASS:Button; TEXT:&Next >]")

; Finish
WinWait($WINDOW, "Completing the Wireshark 1.2.8 (64-bit) Setup Wizard")
WinActivate($WINDOW, "Completing the Wireshark 1.2.8 (64-bit) Setup Wizard")
ControlClick($WINDOW, "", "[CLASS:Button; TEXT:&Finish]")
