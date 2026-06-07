@echo off
setlocal

set "PROJECT_ROOT=%~dp0.."
set "DEFAULT_CLIPS=C:\Program Files\SSS\CLIPS 6.4.2\CLIPSDOS.exe"

if defined CLIPS_EXE if exist "%CLIPS_EXE%" (
    set "CLIPS_BIN=%CLIPS_EXE%"
    goto run
)

if exist "%DEFAULT_CLIPS%" (
    set "CLIPS_BIN=%DEFAULT_CLIPS%"
    goto run
)

where CLIPSDOS.exe >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    set "CLIPS_BIN=CLIPSDOS.exe"
    goto run
)

echo CLIPS nao encontrado.
echo.
echo Defina a variavel CLIPS_EXE com o caminho completo para CLIPSDOS.exe
echo ou instale o CLIPS 6.4.2.
exit /b 1

:run
pushd "%PROJECT_ROOT%" || exit /b 1
"%CLIPS_BIN%" -f2 "clips\debug_cli.clp"
set "STATUS=%ERRORLEVEL%"
popd
exit /b %STATUS%
