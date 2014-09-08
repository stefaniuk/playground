'cscript //nologo hostname.vbs name
'
' name	: new host name
'
'http://msdn.microsoft.com/en-us/library/aa393056%28VS.85%29.aspx

set objArgs = WScript.Arguments
sNewName = objArgs(0)

set oShell = CreateObject ("WSCript.shell" )

sCCS = "HKLM\SYSTEM\CurrentControlSet\"
sTcpipParamsRegPath = sCCS & "Services\Tcpip\Parameters\"
sCompNameRegPath = sCCS & "Control\ComputerName\"

with oShell
	.RegDelete sTcpipParamsRegPath & "Hostname"
	.RegDelete sTcpipParamsRegPath & "NV Hostname"
	.RegWrite sCompNameRegPath & "ComputerName\ComputerName", sNewName
	.RegWrite sCompNameRegPath & "ActiveComputerName\ComputerName", sNewName
	.RegWrite sTcpipParamsRegPath & "Hostname", sNewName
	.RegWrite sTcpipParamsRegPath & "NV Hostname", sNewName
end with
