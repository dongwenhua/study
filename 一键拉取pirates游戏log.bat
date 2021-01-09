adb devices -l|findstr product>dev.txt
for /f "tokens=1,2,3,4,5,6 delims=: " %%i in ('findstr /r "\<product\>" dev.txt') do (
	mkdir %%n
	adb -s %%i pull /sdcard/Android/data/com.seasungames.pirates/files/UE4Game/Pirates/Pirates/Saved/Logs/ %cd%\%%n
	adb -s %%i logcat -d > %cd%\%%n\system.log
)
del dev.txt
pause
