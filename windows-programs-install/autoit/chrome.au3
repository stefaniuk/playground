$EXECUTABLE = "ChromeSetup.exe"
Run($EXECUTABLE)

$WINDOW = "Google - Google Chrome"

WinWait($WINDOW, "")
WinActivate($WINDOW, "")
WinClose($WINDOW, "")
