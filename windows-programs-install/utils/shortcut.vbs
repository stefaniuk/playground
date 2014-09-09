'cscript //nologo shortcut.vbs /F:filename [/T:target] [/P:parameters] [/W:workingdir] [/R:runstyle] [/I:icon,index] [/H:hotkey] [/D:description]
'
' /F:filename    : specifies the .LNK shortcut file
' /T:target      : defines the target path and file name the shortcut points to
' /P:parameters  : defines the command-line parameters to pass to the target
' /W:workingdir  : defines the working directory the target starts with
' /R:runstyle    : defines the window state (1=Normal,3=Max,7=Min)
' /I:icon,index  : defines the icon and optional index (file.exe or file.exe,0)
' /H:hotkey      : defines the hotkey, a numeric value of the keyboard shortcut
' /D:description : defines the description (or comment) for the shortcut
'
'http://msdn.microsoft.com/en-us/library/f5y78918%28VS.85%29.aspx

file = WScript.Arguments.Named("F")
targetPath = WScript.Arguments.Named("T")
arguments = WScript.Arguments.Named("P")
workingDirectory = WScript.Arguments.Named("W")
windowStyle = WScript.Arguments.Named("R")
iconLocation = WScript.Arguments.Named("I")
hotkey = WScript.Arguments.Named("H")
description = WScript.Arguments.Named("D")

set WshShell = WScript.CreateObject("WScript.Shell")
set oWshShortcut = WshShell.CreateShortcut(file)
oWshShortcut.TargetPath = targetPath
oWshShortcut.Arguments = arguments
oWshShortcut.WorkingDirectory = workingDirectory
oWshShortcut.WindowStyle = windowStyle
if iconLocation <> "" then oWshShortcut.IconLocation = iconLocation end if
oWshShortcut.Hotkey = hotkey
oWshShortcut.Description = description

oWshShortcut.Save
