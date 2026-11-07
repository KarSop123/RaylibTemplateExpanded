#!/usr/bin/env bash
# Czysci caly folder build/ (w tym pobrany raylib) i symlink compile_commands.json.
# Uzycie:  ./clean_build.sh
#
# Odpal to, gdy:
# - dostajesz dziwne bledy CMake po zmianach w projekcie
# - chcesz wymusic ponowne pobranie raylib (np. zmieniles GIT_TAG)
set -e

rm -rf build
rm -f compile_commands.json

echo "Wyczyszczono build/ i compile_commands.json."
echo "Nastepne './run.sh' zbuduje projekt od zera (w tym ponownie pobierze raylib)."
