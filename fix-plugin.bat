@echo off
setlocal

REM Go to repo
cd /d "C:\Users\abond\.gemini\antigravity\scratch\discourse-car-registry"

REM Get latest from GitHub
git pull

REM Apply patch file (you already downloaded / will download it as fix-car-registry.patch)
git apply fix-car-registry.patch

REM Commit and push
git add .
git commit -m "Fix plugin engine and namespacing for car registry"
git push

echo.
echo Done. Plugin code fixed and pushed to GitHub.
pause
