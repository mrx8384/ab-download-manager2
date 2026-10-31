@echo off
rem Builds the Windows version of AB Download Manager (installer + portable zip).
rem Installs what is missing: JDK 25, NSIS and the Android SDK (needed by the shared code).
rem Output: build\ci-release\binaries
setlocal EnableExtensions EnableDelayedExpansion
cd /d "%~dp0.."
echo ==== AB Download Manager - Windows build ====
echo.

rem ---------- 1) JDK 25 ----------
set "JAVA_MAJOR="
where java >nul 2>&1
if not errorlevel 1 (
    for /f "tokens=3" %%v in ('java -version 2^>^&1 ^| findstr /i "version"') do set "JAVA_VER=%%~v"
    for /f "delims=." %%m in ("!JAVA_VER!") do set "JAVA_MAJOR=%%m"
)
if not "%JAVA_MAJOR%"=="25" (
    echo [1/4] JDK 25 not found. Installing it with winget...
    winget install -e --id EclipseAdoptium.Temurin.25.JDK --accept-package-agreements --accept-source-agreements
    if errorlevel 1 goto :fail_java
    echo.
    echo JDK 25 installed. Close this window and run this script again.
    pause
    exit /b 0
)
echo [1/4] JDK 25 found.

rem ---------- 2) NSIS (creates the .exe installer) ----------
if not exist "C:\Program Files (x86)\NSIS\makensis.exe" (
    echo [2/4] NSIS not found. Installing it with winget...
    winget install -e --id NSIS.NSIS --accept-package-agreements --accept-source-agreements
    if not exist "C:\Program Files (x86)\NSIS\makensis.exe" goto :fail_nsis
)
echo [2/4] NSIS found.

rem ---------- 3) Android SDK ----------
if exist "local.properties" (
    echo [3/4] local.properties found, using its Android SDK.
    goto :build
)
if defined ANDROID_HOME (
    set "SDK=%ANDROID_HOME%"
) else (
    set "SDK=%LOCALAPPDATA%\Android\Sdk"
)
set "SDKMANAGER=%SDK%\cmdline-tools\latest\bin\sdkmanager.bat"
if not exist "%SDKMANAGER%" (
    echo [3/4] Android SDK not found. Downloading Android command line tools...
    if not exist "%SDK%" mkdir "%SDK%"
    powershell -NoProfile -ExecutionPolicy Bypass -Command ^
      "$ErrorActionPreference='Stop';" ^
      "$zip=Join-Path $env:TEMP 'android-cmdline-tools.zip';" ^
      "Invoke-WebRequest -Uri 'https://dl.google.com/android/repository/commandlinetools-win-13114758_latest.zip' -OutFile $zip;" ^
      "$tmp=Join-Path $env:TEMP 'android-cmdline-tools';" ^
      "if (Test-Path $tmp) { Remove-Item $tmp -Recurse -Force };" ^
      "Expand-Archive $zip $tmp;" ^
      "$dest=Join-Path '%SDK%' 'cmdline-tools\latest';" ^
      "New-Item -ItemType Directory -Force (Split-Path $dest) | Out-Null;" ^
      "if (Test-Path $dest) { Remove-Item $dest -Recurse -Force };" ^
      "Move-Item (Join-Path $tmp 'cmdline-tools') $dest"
    if not exist "%SDKMANAGER%" goto :fail_sdk
)
echo [3/4] Accepting Android SDK licenses...
(for /l %%i in (1,1,30) do @echo y) | call "%SDKMANAGER%" --sdk_root="%SDK%" --licenses >nul
call "%SDKMANAGER%" --sdk_root="%SDK%" "platform-tools"
set "SDK_FWD=%SDK:\=/%"
> local.properties echo sdk.dir=%SDK_FWD%
echo [3/4] Android SDK ready: %SDK%

:build
rem ---------- 4) Build ----------
echo [4/4] Building... (the first time can take a while)
set "SKIP_ANDROID_BUILD=true"
call gradlew.bat createReleaseFolderForCi
if errorlevel 1 goto :fail_build

echo.
echo ==== Done! Files are in build\ci-release\binaries ====
start "" explorer "build\ci-release\binaries"
pause
exit /b 0

:fail_java
echo.
echo Could not install JDK 25. Install it yourself from https://adoptium.net (Temurin 25) and run this script again.
pause
exit /b 1

:fail_nsis
echo.
echo Could not install NSIS. Install it yourself from https://nsis.sourceforge.io/Download and run this script again.
pause
exit /b 1

:fail_sdk
echo.
echo Could not download the Android SDK tools. If Google downloads are blocked for you, turn on a VPN and try again.
pause
exit /b 1

:fail_build
echo.
echo Build failed. Copy the error above and send it.
pause
exit /b 1
