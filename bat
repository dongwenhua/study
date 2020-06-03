@echo off
cd /d %~dp0
REM 1.svn update
::get Local Content dir
set LocalContent=0
for /f "tokens=3,5 delims= " %%i in ('dir Editor') do echo "%%i" | findstr "JUNCTION" && set LocalContent="%%j"
echo %LocalContent:~2,-2%
svn up %LocalContent:~2,-2%

REM 2.Set_GameDataPath   PIRATES_SETTINGS_PATH

echo "%PIRATES_SETTINGS_PATH%" | findstr "%LocalContent:~2,-2%\GameData" && echo Skip_Set_GameDataPath && goto Skip_Set_GameDataPath
setx PIRATES_SETTINGS_PATH "%LocalContent:~2,-2%\GameData"
:Skip_Set_GameDataPath

REM 3.Set_UE4editorPath
echo "%Path%" | findstr "%cd%\UnrealEngine\Engine\Binaries\Win64" && echo Skip_Set_UE4editorPath && goto Skip_Set_UE4editorPath
setx Path "%path%;%cd%\UnrealEngine\Engine\Binaries\Win64"
:Skip_Set_UE4editorPath

REM 4.start  XXXX\Bat\DownloadSublevel
cd Editor\Bat
if exist "DownloadSublevel_OK" goto Skip_DownloadSublevel
start DownloadSublevel.bat
echo DownloadSublevel_OK>DownloadSublevel_OK
:Skip_DownloadSublevel

REM 5.start ServiceAll.bat
tasklist|find /i "java.exe" && echo Service Started Skip_Start_Service && goto Skip_Start_Service
start ServiceAll.bat && echo Start Service
:Skip_Start_Service

REM 6.start Uncooked Dungeon
cd services
if not exist "pirates" goto First_Set_Skip_Start_Dungeon && echo First_Set_Skip_Start_Dungeon
cd ..
cd ..
cd ..
start /d "%cd%\UnrealEngine\Engine\Binaries\Win64" UE4Editor-Cmd.exe "%CD%\Editor\Pirates.uproject" -run=Editor -EditorScript -params=TargetType:Editor,ExportMode:Iterate -stdout
start /d "%cd%\UnrealEngine\Engine\Binaries\Win64" UE4Editor.exe "%CD%\Editor\Pirates.uproject" -server -log -stdout -dungeon publicip=127.0.0.1 instanceid=INSTANCE1 -triggercrashduetoluaerror

:First_Set_Skip_Start_Dungeon
pause
