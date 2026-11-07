@echo off
REM Zmienia nazwe gry/projektu. Jedyne miejsce w calym projekcie, ktore trzeba
REM tknac, to CMakeLists.txt - ten skrypt robi to automatycznie.
REM Uzycie:  rename_game.bat MojaSuperGra

if "%~1"=="" (
    echo Uzycie: rename_game.bat NowaNazwa
    echo Przyklad: rename_game.bat SpaceShooter
    exit /b 1
)

set NEW_NAME=%~1

if not exist CMakeLists.txt (
    echo Blad: nie znaleziono CMakeLists.txt w biezacym katalogu.
    echo Uruchom ten skrypt z glownego folderu projektu.
    exit /b 1
)

powershell -NoProfile -Command ^
    "(Get-Content CMakeLists.txt) -replace '^project\([A-Za-z0-9_]+ CXX\)', 'project(%NEW_NAME% CXX)' | Set-Content CMakeLists.txt"

echo Zmieniono nazwe projektu na: %NEW_NAME%
echo.
echo Wyczysc stary build i zbuduj ponownie, zeby zmiana zadzialala:
echo   clean_build.bat ^&^& run.bat
