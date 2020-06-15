@echo off
setlocal
:PROMPT
set /p choice="Would you like to download remote changes (D) or upload local changes (U)? "
if /i "%choice%" NEQ "D" GOTO UPLOAD
git pull origin master
GOTO END
:UPLOAD
git add .
set /p comment="Briefly describe your changes: "
git commit -m "%comment%"
git push origin master
:END
endlocal
pause