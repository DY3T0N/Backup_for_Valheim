:LOOP
@echo off

:: Variable for path
:: Change the path after backup_path= to place the backups to a different path
:: If the path contains spaces, "" <-- these are needed in order for it to work eg.: C:\"example path" 
set save_path=%UserProfile%\appdata\locallow\irongate
set backup_path=%save_path%\valheim_backup

:: Create timestamp variable
set year=%date:~10,4%
set month=%date:~4,2%
set day=%date:~7,2%
set hour="%time:~0,2%"
set min="%time:~3,2%"
set timestamp=%year%-%month%-%day%(%hour%-%min%)

:: Copy save folder into valheim_backup folder
ROBOCOPY %save_path%\valheim %backup_path%\%timestamp% /E > NUL 2>&1

:: Preserve only the %MaxBackups% most recent backups.
:: Change the number after MaxBackups= to get the desired amount of backup files
set MaxBackups=5
set "delMsg="
for /f "skip=%MaxBackups% delims=" %%a in (
  'dir "%backup_path%\*" /t:c /a:d /o:-d /b'
) do (
  if not defined delMsg (
    set delMsg=1
    echo More than %MaxBackups% backups found - oldest backup deleted.
  )
  rd /s /q "%backup_path%\%%a"
)

echo Backup created at %timestamp%

:: Wait time before loop restart
timeout /t 1800 /nobreak > NUL

:: Timeout set to 1800 sec = 30 min

goto LOOP