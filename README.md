# Raylib + CMake - Uniwersalny szablon gry (C++)

Gotowy szablon, w którym:
- **raylib pobiera się automatycznie** z GitHuba (najnowsza wersja z gałęzi `master`) przy pierwszej konfiguracji - nie musisz nic instalować ręcznie.
- **Nowe pliki `.cpp`/`.h` w `src/` są wykrywane automatycznie** (wystarczy odpalić build ponownie, nie trzeba nic dopisywać w CMakeLists.txt).
- **Assety (`assets/`) są kopiowane obok pliku wykonywalnego** po każdej kompilacji, więc gra zawsze je znajdzie, gdziekolwiek ją uruchomisz.
- **Folder `assets/` nie znika po wrzuceniu na GitHub** - `.gitignore` ignoruje tylko `build/`, a `.gitkeep` pilnuje, żeby pusty folder assets też trafiał do repo.

## Struktura

```
.
├── CMakeLists.txt        <- serce projektu, nic tu nie trzeba ruszać
├── CMakePresets.json      <- proste komendy budowania
├── run.sh / run.bat       <- build + odpalenie gry jedną komendą
├── src/                   <- Twój kod (main.cpp + wszystko co dodasz)
└── assets/                <- grafiki, dźwięki, fonty, mapy itd.
```

## Jak dodawać rzeczy do projektu

- **Nowy plik gry** -> wrzuć `.cpp`/`.h` do `src/` (można w podfolderach) i po prostu zbuduj projekt ponownie.
- **Nowy asset** -> wrzuć plik do `assets/` i odwołuj się do niego w kodzie jak w `main.cpp`:
  ```cpp
  LoadTexture(AssetPath("obrazek.png").c_str());
  ```
- **Podfoldery w assets** (np. `assets/sounds/`, `assets/textures/`) też działają - są kopiowane w całości.

## Budowanie i odpalanie

### Najprościej (jedna komenda):

Linux / macOS:
```bash
./run.sh
```

Windows:
```bat
run.bat
```

### Ręcznie, przez presety CMake:
```bash
cmake --preset default
cmake --build --preset default
./build/bin/MyGame        # Linux/macOS
build\bin\Release\MyGame.exe   # Windows (Visual Studio)
```

### Klasycznie:
```bash
mkdir build && cd build
cmake ..
cmake --build .
./bin/MyGame
```

## Wymagania

- CMake >= 3.15
- Kompilator C++17 (GCC, Clang, MSVC)
- Połączenie z internetem przy pierwszym budowaniu (pobranie raylib)
- Linux: pakiety systemowe dla raylib (X11, OpenGL), np. na Ubuntu/Debian:
  ```bash
  sudo apt install libgl1-mesa-dev libx11-dev libxrandr-dev libxi-dev libxcursor-dev libxinerama-dev
  ```

## Czyszczenie builda

Jeśli po zmianach w projekcie CMake zaczyna dziwnie marudzić (np. błędy
konfiguracji po edycji CMakeLists.txt, albo chcesz wymusić ponowne
pobranie raylib po zmianie wersji), wyczyść build:

Linux / macOS:
```bash
./clean_build.sh
```

Windows:
```bat
clean_build.bat
```

Usuwa cały folder `build/` (razem z pobranym raylib) i symlink
`compile_commands.json`. Kolejne `./run.sh` zbuduje wszystko od zera.

## Zmiana wersji raylib

Wersja jest **przypięta na sztywno** (tag `6.0`), a nie ciągnięta z gałęzi
`master`. Powód: `master` to ruchomy branch deweloperski - przy każdej
konfiguracji CMake musiałby sprawdzać w GitHubie, czy są nowe commity, co
przy częstym budowaniu (albo w CI) łatwo trafia w limit zapytań GitHuba dla
niezalogowanych użytkowników i psuje build błędem w stylu:
```
fatal: remote error: GitHub is temporarily limiting some unauthenticated downloads...
```
Dodatkowo w `CMakeLists.txt` włączone jest `FETCHCONTENT_UPDATES_DISCONNECTED`,
więc nawet przy przypiętym tagu CMake nie odpytuje GitHuba ponownie przy
kolejnych konfiguracjach tego samego builda - tylko raz, przy pierwszym
pobraniu.

Żeby zaktualizować raylib do nowszej wersji:
1. Sprawdź dostępne tagi: https://github.com/raysan5/raylib/tags
2. W `CMakeLists.txt` zmień:
   ```cmake
   GIT_TAG 6.0
   ```
   na nowszy tag, np. `GIT_TAG 6.1`
3. Uruchom `./clean_build.sh` (albo `clean_build.bat`), żeby wymusić
   pobranie nowej wersji, a potem `./run.sh`.

## LSP w Neovim (clangd) - podpowiedzi kodu dla raylib

`CMakeLists.txt` ma włączone `CMAKE_EXPORT_COMPILE_COMMANDS`, więc CMake
generuje `build/compile_commands.json` ze wszystkimi flagami i ścieżkami
nagłówków (w tym do raylib). `clangd` szuka tego pliku w katalogu głównym
projektu, dlatego `run.sh` automatycznie robi do niego symlink po buildzie.

1. Zainstaluj clangd, np. przez Mason w nvim: `:MasonInstall clangd`
2. Podłącz go w konfiguracji nvim (np. `nvim-lspconfig`):
   ```lua
   require("lspconfig").clangd.setup({
     cmd = { "clangd", "--background-index", "--clang-tidy" },
   })
   ```
3. Zbuduj projekt raz (`./run.sh` lub `cmake --preset default && cmake --build --preset default`) - to utworzy `compile_commands.json` w katalogu głównym.
4. Otwórz `src/main.cpp` w nvim - podpowiedzi, go-to-definition i błędy dla `raylib.h` powinny działać od razu.

Jeśli LSP dalej nie widzi raylib, sprawdź w nvim: `:LspInfo` (czy clangd wystartował)
oraz upewnij się, że `compile_commands.json` istnieje w root projektu (nie tylko w `build/`).

Na Windows symlinki wymagają uprawnień administratora - `run.bat` tego nie robi
automatycznie. Zamiast tego po buildzie skopiuj plik ręcznie:
```bat
copy build\compile_commands.json compile_commands.json
```
albo użyj WSL, gdzie działa `run.sh` normalnie.

## Nazwa projektu / gry

Nazwę zmienisz jedną komendą - nie musisz nic edytować ręcznie w kilku plikach,
`run.sh`/`run.bat` same wykrywają zbudowany plik wykonywalny:

Linux / macOS:
```bash
./rename_game.sh SpaceShooter
./clean_build.sh && ./run.sh
```

Windows:
```bat
rename_game.bat SpaceShooter
clean_build.bat && run.bat
```

Nazwa może zawierać tylko litery, cyfry i podkreślniki (bez spacji i polskich
znaków) - to wymóg CMake dla nazwy targetu. Skrypt zmienia jedyne miejsce,
w którym nazwa jest zapisana na sztywno: linię `project(...)` w
`CMakeLists.txt`. Wyczyszczenie builda po zmianie jest konieczne, żeby CMake
przegenerował pliki projektu pod nową nazwą.
