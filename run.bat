@echo off
REM Buduje i od razu odpala gre. Uzycie:  run.bat
REM
REM Nazwa gry nie jest tu na sztywno wpisana - skrypt sam znajduje zbudowany
REM plik .exe. Zeby zmienic nazwe gry, uzyj rename_game.bat

cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
if errorlevel 1 exit /b 1

cmake --build build --config Release
if errorlevel 1 exit /b 1

if exist build\bin\Release (
    set BINDIR=build\bin\Release
) else (
    set BINDIR=build\bin
)

for %%f in (%BINDIR%\*.exe) do set EXE=%%f

if not defined EXE (
    echo Nie znaleziono zbudowanego pliku .exe w %BINDIR%
    exit /b 1
)

"%EXE%"
