@echo off
cd /d "E:\Sitara\New Folder\sitara777"
echo Building release APK...
call flutter build apk --release
if %errorlevel% == 0 (
  echo APK build completed successfully!
) else (
  echo APK build failed with error code %errorlevel%
)
pause