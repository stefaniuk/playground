@echo off

set TMP=%1
set BASE_DIR=%TMP:/=\%
set TMP=%2
set SPRITE_OPTION_FILE=%TMP:/=\%

echo Generate sprites from option file %SPRITE_OPTION_FILE%
java -classpath %BASE_DIR%\utils\com.code4ge.webtools.jar;%BASE_DIR%\utils\com.code4ge.json.jar;%BASE_DIR%\utils\com.code4ge.args4j.jar;%BASE_DIR%\utils\commons-lang-2.5.jar ^
	com.code4ge.webtools.sprite.Build --image-magick-dir %IMAGEMAGICK_HOME% --option-file %SPRITE_OPTION_FILE%
