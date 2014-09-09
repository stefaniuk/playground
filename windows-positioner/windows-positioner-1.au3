; screen: 1440 x 900
; left bar: 31 x 870
; task bar: 1440 x 30

local $list

; Total Commander
$list = WinList("Total Commander")
for $i = 1 to $list[0][0]
    if $list[$i][0] <> "" and IsVisible($list[$i][1]) then
        WinMove($list[$i][1], "", 31, 0, 750, 570)
    endif
next

; PuTTY
$list = WinList("[CLASS:PuTTY]")
for $i = 1 to $list[0][0]
    if $list[$i][0] <> "" and IsVisible($list[$i][1]) then
        WinMove($list[$i][1], "", 31, 570, 650, 300)
    endif
next

; Notepad++
$list = WinList("[CLASS:Notepad++]")
for $i = 1 to $list[0][0]
    if $list[$i][0] <> "" and IsVisible($list[$i][1]) then
        WinMove($list[$i][1], "", 681, 0, 759, 870)
    endif
next

; WinSCP
$list = WinList("[CLASS:TScpCommanderForm]")
for $i = 1 to $list[0][0]
    if $list[$i][0] <> "" and IsVisible($list[$i][1]) then
        WinMove($list[$i][1], "", 681, 370, 759, 500)
    endif
next

; Chrome
$list = WinList("[REGEXPCLASS:.*Chrome]")
for $i = 1 to $list[0][0]
    if $list[$i][0] <> "" and IsVisible($list[$i][1]) then
        WinMove($list[$i][1], "", 440, 0, 1000, 870)
    endif
next

; Firefox
$list = WinList("[CLASS:MozillaWindowClass]")
for $i = 1 to $list[0][0]
    if $list[$i][0] <> "" and IsVisible($list[$i][1]) then
        WinMove($list[$i][1], "", 31, 0, 1000, 720)
    endif
next

; Firebug
$list = WinList("Firebug")
for $i = 1 to $list[0][0]
    if $list[$i][0] <> "" and IsVisible($list[$i][1]) then
        WinMove($list[$i][1], "", 440, 570, 1000, 300)
    endif
next

; Eclipse
$list = WinList("[REGEXPCLASS:SWT.*]")
for $i = 1 to $list[0][0]
    if $list[$i][0] <> "" and IsVisible($list[$i][1]) then
        WinMove($list[$i][1], "", 31, 0, 1000, 870)
    endif
next

; CMD: Tomcat
$list = WinList("[TITLE:Tomcat;CLASS:ConsoleWindowClass]")
for $i = 1 to $list[0][0]
    if $list[$i][0] <> "" and IsVisible($list[$i][1]) then
        WinMove($list[$i][1], "", 31, 0, 749, 870)
    endif
next

; Outlook
$list = WinList("[CLASS:rctrl_renwnd32]")
for $i = 1 to $list[0][0]
    if $list[$i][0] <> "" and IsVisible($list[$i][1]) then
        WinMove($list[$i][1], "", 440, 0, 1000, 870)
    endif
next

; Office Communicator
$list = WinList("[CLASS:CommunicatorMainWindowClass]")
for $i = 1 to $list[0][0]
    if $list[$i][0] <> "" and IsVisible($list[$i][1]) then
        WinMove($list[$i][1], "", 31, 0, 320, 870)
    endif
next

;
; functions
;

func IsVisible($handle)
    if BitAND(WinGetState($handle), 2) then
        return 1
    else
        return 0
    endif
endfunc
