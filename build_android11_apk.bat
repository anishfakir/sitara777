@echo off
cd /d "E:\Sitara\New Folder\sitara777"
echo Building APK for Android 11+ compatibility...
echo Cleaning previous builds...
call flutter clean
echo Getting dependencies...
call flutter pub get
echo Building release APK...
call flutter build apk --release
if %errorlevel% == 0 (
  echo.
  echo APK build completed successfully!
  echo APK location: build\app\outputs\flutter-apk\app-release.apk
) else (
  echo.
  echo APK build failed with error code %errorlevel%
)
pause