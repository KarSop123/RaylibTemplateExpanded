#!/usr/bin/env bash
# Zmienia nazwe gry/projektu. Jedyne miejsce w calym projekcie, ktore trzeba
# tknac, to CMakeLists.txt - ten skrypt robi to automatycznie.
# Uzycie:  ./rename_game.sh MojaSuperGra
set -e

if [ -z "$1" ]; then
    echo "Uzycie: ./rename_game.sh NowaNazwa"
    echo "Przyklad: ./rename_game.sh SpaceShooter"
    exit 1
fi

NEW_NAME="$1"

# Prosta walidacja - nazwa CMake nie powinna miec spacji ani znakow specjalnych
if [[ ! "$NEW_NAME" =~ ^[A-Za-z0-9_]+$ ]]; then
    echo "Blad: nazwa moze zawierac tylko litery, cyfry i podkreslniki (bez spacji/polskich znakow)."
    echo "Przyklad dobrej nazwy: SpaceShooter, moja_gra, Gra2"
    exit 1
fi

if [ ! -f "CMakeLists.txt" ]; then
    echo "Blad: nie znaleziono CMakeLists.txt w biezacym katalogu."
    echo "Uruchom ten skrypt z glownego folderu projektu."
    exit 1
fi

if ! grep -qE '^project\([A-Za-z0-9_]+ CXX\)' CMakeLists.txt; then
    echo "Blad: nie znaleziono linii project(... CXX) w CMakeLists.txt."
    echo "Zmien nazwe recznie w tej jednej linii."
    exit 1
fi

OLD_NAME=$(grep -E '^project\(' CMakeLists.txt | sed -E 's/^project\(([A-Za-z0-9_]+) CXX\).*/\1/')

# macOS (BSD sed) wymaga podania '' po -i, Linux (GNU sed) nie - obsluga obu
if sed --version >/dev/null 2>&1; then
    sed -i -E "s/^project\([A-Za-z0-9_]+ CXX\)/project(${NEW_NAME} CXX)/" CMakeLists.txt
else
    sed -i '' -E "s/^project\([A-Za-z0-9_]+ CXX\)/project(${NEW_NAME} CXX)/" CMakeLists.txt
fi

echo "Zmieniono nazwe projektu: ${OLD_NAME} -> ${NEW_NAME}"
echo ""
echo "Wyczysc stary build i zbuduj ponownie, zeby zmiana zadzialala:"
echo "  ./clean_build.sh && ./run.sh"
