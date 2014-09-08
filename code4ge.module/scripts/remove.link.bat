@echo off

if exist %1 junction -d %1 && echo Remove link %1
