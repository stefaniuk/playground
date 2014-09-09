; screen: 1680 x 1050
; task bar: 1680 x 40

local $list

; Total Commander
$list = WinList("Total Commander")
for $i = 1 to $list[0][0]
    if $list[$i][0] <> "" and IsVisible($list[$i][1]) then
        WinMove($list[$i][1], "", 0, 0, 820, 580)
    endif
next

; PuTTY
$list = WinList("[CLASS:PuTTY]")
for $i = 1 to $list[0][0]
    if $list[$i][0] <> "" and IsVisible($list[$i][1]) then
        WinMove($list[$i][1], "", 0, 580, 820, 430)
    endif
next

; Notepad++
$list = WinList("[CLASS:Notepad++]")
for $i = 1 to $list[0][0]
    if $list[$i][0] <> "" and IsVisible($list[$i][1]) then
        WinMove($list[$i][1], "", 820, 0, 860, 1010)
    endif
next

; WinSCP
$list = WinList("[CLASS:TScpCommanderForm]")
for $i = 1 to $list[0][0]
    if $list[$i][0] <> "" and IsVisible($list[$i][1]) then
        WinMove($list[$i][1], "", 820, 420, 860, 590)
    endif
next

; Chrome
$list = WinList("[REGEXPCLASS:.*Chrome]")
for $i = 1 to $list[0][0]
    if $list[$i][0] <> "" and IsVisible($list[$i][1]) then
        WinMove($list[$i][1], "", 580, 0, 1100, 1010)
    endif
next

; Firefox
$list = WinList("[CLASS:MozillaWindowClass]")
for $i = 1 to $list[0][0]
    if $list[$i][0] <> "" and IsVisible($list[$i][1]) then
        WinMove($list[$i][1], "", 0, 0, 1100, 750)
    endif
next

; Firebug
$list = WinList("Firebug")
for $i = 1 to $list[0][0]
    if $list[$i][0] <> "" and IsVisible($list[$i][1]) then
        WinMove($list[$i][1], "", 580, 580, 1100, 430)
    endif
next

; CMD
$list = WinList("[TITLE:Administrator;CLASS:ConsoleWindowClass]")
for $i = 1 to $list[0][0]
    if $list[$i][0] <> "" and IsVisible($list[$i][1]) then
        WinMove($list[$i][1], "", 0, 0, 820, 580)
    endif
next

; Visual C++/C# Express
$list = WinList("[REGEXPTITLE:.*Visual C[\+\+#]* 20\d\d Express.*]")
for $i = 1 to $list[0][0]
    if $list[$i][0] <> "" and IsVisible($list[$i][1]) then
        WinMove($list[$i][1], "", 520, 0, 1160, 1010)
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
