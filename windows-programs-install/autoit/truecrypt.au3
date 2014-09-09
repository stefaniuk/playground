$EXECUTABLE = "TrueCrypt Setup " & $CmdLine[1] & ".exe"
Run($EXECUTABLE)

$WINDOW = "TrueCrypt Setup " & $CmdLine[1]

WinWait($WINDOW, "License")
WinActivate($WINDOW, "License")
Send("{TAB}{TAB}{SPACE}")
Sleep(250)
ControlClick($WINDOW, "", "[CLASS:Button; TEXT:&Next >]")
Sleep(250)

; Wizard Mode
WinWait($WINDOW, "Wizard Mode")
WinActivate($WINDOW, "Wizard Mode")
ControlClick($WINDOW, "", "[CLASS:Button; TEXT:&Next >]")
Sleep(250)

; Setup Options
WinWait($WINDOW, "Setup Options")
WinActivate($WINDOW, "Setup Options")
Send("{TAB}{TAB}{TAB}{TAB}{TAB}{TAB}{TAB}{SPACE}")
Sleep(250)
ControlClick($WINDOW, "", "[CLASS:Button; TEXT:&Next >]")
Sleep(250)

; Setup Options
WinWait($WINDOW, "")
WinActivate($WINDOW, "")
ControlClick($WINDOW, "", "[CLASS:Button; TEXT:&Install]")
Sleep(250)

; TODO: form this point use Send function instead of ControlClick

; TrueCrypt has been successfully installed
WinWait("TrueCrypt Setup", "TrueCrypt has been successfully installed")
WinActivate("TrueCrypt Setup", "TrueCrypt has been successfully installed")
ControlClick("TrueCrypt Setup", "", "[CLASS:Button; TEXT:OK]")
Sleep(250)

; TrueCrypt has been successfully installed
WinWait($WINDOW, "TrueCrypt has been successfully installed")
WinActivate($WINDOW, "TrueCrypt has been successfully installed")
ControlClick($WINDOW, "", "[CLASS:Button; TEXT:&Finish]")
Sleep(250)

; If you have never used TrueCrypt before
WinWait("TrueCrypt Setup", "If you have never used TrueCrypt before")
WinActivate("TrueCrypt Setup", "If you have never used TrueCrypt before")
ControlClick("TrueCrypt Setup", "", "[CLASS:Button; TEXT:&No]")
