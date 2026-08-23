@echo off
cd /d "%~dp0"
echo ===================================================
echo   Pushing Discourse Car Registry to GitHub
echo ===================================================
echo.
"C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\CommonExtensions\Microsoft\TeamFoundation\Team Explorer\Git\cmd\git.exe" push -u origin main
echo.
pause