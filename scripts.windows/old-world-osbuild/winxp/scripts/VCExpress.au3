$EXECUTABLE = $CMDLINE[1] & "\VCExpress\setup.exe"
Run($EXECUTABLE)

$WINDOW = "Microsoft Visual C++ 2008 Express Edition with SP1 Setup"

; Welcome to Setup
WinWait($WINDOW)
WinActivate($WINDOW)
ControlClick($WINDOW, "", "[CLASS:Button; TEXT:&Next >]")
Sleep(1000)

; License Terms
WinWait($WINDOW)
WinActivate($WINDOW)
ControlCommand($WINDOW, "", "[CLASS:Button; TEXT:I have read and &accept the license terms]", "Check", "")
ControlClick($WINDOW, "", "[CLASS:Button; TEXT:&Next >]")
Sleep(1000)

; Installation Options
WinWait($WINDOW)
WinActivate($WINDOW)
ControlCommand($WINDOW, "", "[CLASS:Button; TEXT:Microsoft SQL Server 2008 Express Edition (x64)]", "UnCheck", "")
ControlClick($WINDOW, "", "[CLASS:Button; TEXT:&Next >]")
Sleep(1000)

; Destination Folder
WinWait($WINDOW)
WinActivate($WINDOW)
ControlClick($WINDOW, "", "[CLASS:Button; TEXT:I&nstall >]")

; Setup complete
WinWait($WINDOW, "Setup complete")
WinActivate($WINDOW, "Setup complete")
ControlClick($WINDOW, "", "[CLASS:Button; TEXT:E&xit]")
