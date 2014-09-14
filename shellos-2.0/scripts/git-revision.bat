@echo off

git rev-list --all | find /c /v "---"

