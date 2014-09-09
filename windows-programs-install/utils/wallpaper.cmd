@echo off
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d %1 /f
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /V WallpaperStyle /t REG_SZ /d 2 /f
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v TileWallpaper /t REG_SZ /D 0 /f
rundll32.exe user32.dll, UpdatePerUserSystemParameters
