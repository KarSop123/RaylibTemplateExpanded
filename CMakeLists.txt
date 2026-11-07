cmake_minimum_required(VERSION 3.15)
project(Super_Gierka CXX)

# ---------------------------------------------------------------------------
# Podstawowa konfiguracja
# ---------------------------------------------------------------------------
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
    set(CMAKE_BUILD_TYPE Release CACHE STRING "Build type" FORCE)
endif()

# Wszystko (exe) ląduje w jednym, przewidywalnym miejscu: build/bin
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

# ---------------------------------------------------------------------------
# Pobieranie raylib z GitHuba - wersja PRZYPIĘTA (nie "master").
#
# Dlaczego nie "master": to ruchomy branch deweloperski - przy kazdej
# konfiguracji CMake musialby odpytywac GitHub czy sa nowe commity, co przy
# czestym budowaniu latwo wpada w limit zapytan GitHuba dla niezalogowanych
# ("update step" w logu bledu). Przypiety tag jest szybszy, stabilny
# i powtarzalny.
#
# Zeby zaktualizowac raylib w przyszlosci: zmien GIT_TAG na nowszy tag
# (lista: https://github.com/raysan5/raylib/tags) i uruchom clean_build.
# ---------------------------------------------------------------------------
include(FetchContent)
set(FETCHCONTENT_QUIET FALSE)

# Nie sprawdzaj aktualizacji przy kazdym "configure" - raz pobrane, zostaje.
# To dodatkowo chroni przed limitem zapytan GitHuba przy powtarzanych buildach.
set(FETCHCONTENT_UPDATES_DISCONNECTED ON)

set(BUILD_EXAMPLES OFF CACHE BOOL "" FORCE)
set(BUILD_GAMES OFF CACHE BOOL "" FORCE)
set(SUPPORT_BUILD_AS_EMBEDDED OFF CACHE BOOL "" FORCE)

FetchContent_Declare(
    raylib
    GIT_REPOSITORY https://github.com/raysan5/raylib.git
    GIT_TAG        6.0
    GIT_SHALLOW    TRUE
)
FetchContent_MakeAvailable(raylib)

# ---------------------------------------------------------------------------
# Pliki źródłowe - dodawane AUTOMATYCZNIE.
# Wystarczy wrzucić nowy .cpp/.h do src/ i zrobić ponowny "configure"
# (CONFIGURE_DEPENDS sprawia, że dzieje się to samo przy zwykłym buildzie).
# ---------------------------------------------------------------------------
file(GLOB_RECURSE PROJECT_SOURCES CONFIGURE_DEPENDS
    ${CMAKE_SOURCE_DIR}/src/*.cpp
    ${CMAKE_SOURCE_DIR}/src/*.h
    ${CMAKE_SOURCE_DIR}/src/*.hpp
)

add_executable(${PROJECT_NAME} ${PROJECT_SOURCES})

target_include_directories(${PROJECT_NAME} PRIVATE ${CMAKE_SOURCE_DIR}/src)
target_link_libraries(${PROJECT_NAME} PRIVATE raylib)

# Wymagane frameworki na macOS
if(APPLE)
    target_link_libraries(${PROJECT_NAME} PRIVATE
        "-framework IOKit"
        "-framework Cocoa"
        "-framework OpenGL"
    )
endif()

# Cieplejsze ostrzeżenia kompilatora (opcjonalnie, nie blokuje builda)
if(MSVC)
    target_compile_options(${PROJECT_NAME} PRIVATE /W3)
else()
    target_compile_options(${PROJECT_NAME} PRIVATE -Wall -Wextra)
endif()

# ---------------------------------------------------------------------------
# Assety - kopiowane obok gotowego .exe/binarki po KAŻDEJ kompilacji.
# Dzięki temu gra zawsze znajdzie swoje pliki, niezależnie skąd ją odpalisz.
# ---------------------------------------------------------------------------
add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_directory
            ${CMAKE_SOURCE_DIR}/assets
            $<TARGET_FILE_DIR:${PROJECT_NAME}>/assets
    COMMENT "Kopiowanie assetow obok pliku wykonywalnego..."
)
