$EXECUTABLE = "ChromeSetup.exe"
Run($EXECUTABLE)

$WINDOW = "Welcome to Google Chrome"

WinWait($WINDOW, "Make Google Chrome the default browser")
WinActivate($WINDOW, "Make Google Chrome the default browser")
ControlCommand($WINDOW, "", "[CLASS:Button; TEXT:Make Google Chrome the default browser]", "UnCheck", "")
ControlClick($WINDOW, "", "[CLASS:Button; TEXT:Start Google Chrome]")
