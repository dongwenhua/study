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
:: 1=i 2=j 3=k 4=l 5=m 6=n 7=o 8=p 9=q
set x=n
for /f "delims=" %%i in (patches.txt) do call set "var=%%var%%%%i"
for /f "tokens=1,2,3,4,5,6 delims={" %%i in ("%var%") do set "var=%%%x%"
for /f "tokens=1,2,3,4,5 delims=," %%i in ("%var%") do (
    set SIZE=%%k 
    set SHA1=%%j
    set NUMBER=%%l
    set FROM=%%i
)
echo %SIZE:~12% 
echo %SHA1:~13,-1% 
echo %NUMBER:~10% 
echo %FROM:~12%

set DownUrl="%PAKURL%lastSuccessfulBuild/artifact/pirates-patch_%NUMBER:~10%_P.pak"

del /f/s/q Paks\*

%CURLEXE% --ssl-no-revoke -L -o "Paks\patch_%NUMBER:~10%_P.pak" %DownUrl%

del /f/s/q update.info

echo { > update.info
echo 	"baseversion": %FROM:~12%, >> update.info
echo 	"curversion": %NUMBER:~10%, >> update.info
echo 	"etag": "\"%ETAG:~1,-1%\"", >> update.info
echo 	"patches": [ >> update.info
echo 		{ >> update.info
echo 			"version": %NUMBER:~10%, >> update.info
echo 			"pakfilename": "patch_%NUMBER:~10%_P.pak", >> update.info
echo 			"size": "%SIZE:~12%", >> update.info
echo 			"sha1": "%SHA1:~13,-1%" >> update.info
echo 		} >> update.info
echo 	] >> update.info
echo } >> update.info

adb push Paks /sdcard/Android/data/com.seasungames.pirates/files
adb push update.info /sdcard/Android/data/com.seasungames.pirates/files

del /f/s/q head.txt
del /f/s/q patches.txt

pause
