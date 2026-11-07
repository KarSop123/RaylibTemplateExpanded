@echo off
REM Czysci caly folder build (w tym pobrany raylib) i compile_commands.json.
REM Uzycie:  clean_build.bat
REM
REM Odpal to, gdy:
REM - dostajesz dziwne bledy CMake po zmianach w projekcie
REM - chcesz wymusic ponowne pobranie raylib (np. zmieniles GIT_TAG)

if exist build (
    rmdir /s /q build
)
if exist compile_commands.json (
    del /q compile_commands.json
)

echo Wyczyszczono build i compile_commands.json.
echo Nastepne "run.bat" zbuduje projekt od zera (w tym ponownie pobierze raylib).
