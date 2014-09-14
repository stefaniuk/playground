@echo off

set "arg1=%1"
set "arg2=%2"

copy "%arg1:/=\%" "%arg2:/=\%"

