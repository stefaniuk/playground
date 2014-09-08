@echo off

if exist %2 junction -d %2
junction %2 %1 && echo Create link from %2 to %1
