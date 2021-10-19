@echo on
set MANIFESTJSONURL= "https://s3.cn-northwest-1.amazonaws.com.cn/sog-dev-1/client/patch/android/manifest.json"

set PAKURL=https://jenkins.klmagic.com/job/Pirates/job/Tools/job/patching-android/

::CURL.EXE
set CURLEXE=%cd%\bin\CURL.EXE
::jq-win64.exe
set JQEXE=%cd%\bin\jq-win64.exe

::ETag
set ETAG=0
%CURLEXE% -I %MANIFESTJSONURL% > head.txt

for /f "tokens=1,2 delims=: " %%i in ('findstr /r "ETag:" head.txt') do (
	echo %%i %%j
    set ETAG=%%j
)

::size
set SIZE=0
::sha1
set SHA1=0
::number
set NUMBER=0
::from
set FROM=0

%CURLEXE% %MANIFESTJSONURL% | %JQEXE% ".patches" > patches.txt
for /f "tokens=* delims=" %%i in ('findstr /r ":" patches.txt') do (
    echo %%i > a.txt
    findstr /r "from" a.txt && set FROM=%%i
    findstr /r "sha1" a.txt && set SHA1=%%i
    findstr /r "size" a.txt && set SIZE=%%i
    findstr /r "%NUMBER%" a.txt && goto BREAKFOR
)
echo %FROM:~12,-1%
echo %SHA1:~13,-2%
echo %SIZE:~12,-1%

set DownUrl="%PAKURL%lastSuccessfulBuild/artifact/pirates-patch_%NUMBER%_P.pak"

del /f/s/q Paks\*

%CURLEXE% --ssl-no-revoke -L -o "Paks\patch_%NUMBER%_P.pak" %DownUrl%

del /f/s/q update.info

echo { > update.info
echo 	"baseversion": %FROM:~12,-1%, >> update.info
echo 	"curversion": %NUMBER%, >> update.info
echo 	"etag": "\"%ETAG:~1,-1%\"", >> update.info
echo 	"patches": [ >> update.info
echo 		{ >> update.info
echo 			"version": %NUMBER%, >> update.info
echo 			"pakfilename": "patch_%NUMBER%_P.pak", >> update.info
echo 			"size": "%SIZE:~12,-1%", >> update.info
echo 			"sha1": "%SHA1:~13,-2%" >> update.info
echo 		} >> update.info
echo 	] >> update.info
echo } >> update.info

adb push Paks /sdcard/Android/data/com.seasungames.pirates/files
adb push update.info /sdcard/Android/data/com.seasungames.pirates/files

del /f/s/q head.txt
del /f/s/q patches.txt
del /f/s/q a.txt

pause
