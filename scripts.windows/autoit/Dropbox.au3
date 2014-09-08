$EXECUTABLE = "Dropbox 1.0.20.exe"
Run($EXECUTABLE)

$WINDOW = "Dropbox Setup"

; Welcome
WinWait($WINDOW, "Welcome to Dropbox Setup")
WinActivate($WINDOW, "Welcome to Dropbox Setup")
ControlClick($WINDOW, "", "[CLASS:Button; INSTANCE:2]")

; Account
WinWait($WINDOW, "I already have a Dropbox account")
WinActivate($WINDOW, "I already have a Dropbox account")
Sleep(1000)
WinKill($WINDOW, "I already have a Dropbox account")
