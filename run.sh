#!/usr/bin/env bash
# Buduje i od razu odpala gre. Uzycie:  ./run.sh
#
# Nazwa gry nie jest tu na sztywno wpisana - skrypt sam znajduje zbudowany
# plik wykonywalny w build/bin/. Zeby zmienic nazwe gry, uzyj ./rename_game.sh
set -e

cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build -j"$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 4)"

# Symlink dla clangd (LSP), zeby widzial flagi kompilacji i naglowki raylib
ln -sf build/compile_commands.json compile_commands.json

cd build/bin

# Znajdz plik wykonywalny (jedyny plik z prawem wykonywania w tym katalogu)
EXE=$(find . -maxdepth 1 -type f -perm -u+x | head -n 1)

if [ -z "$EXE" ]; then
    echo "Nie znaleziono zbudowanego pliku wykonywalnego w build/bin/"
    exit 1
fi

exec "$EXE"
