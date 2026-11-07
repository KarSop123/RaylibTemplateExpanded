#include "raylib.h"
#include <string>

// Buduje sciezke do pliku w folderze assets/, ktory lezy zawsze
// obok pliku wykonywalnego (niezaleznie skad odpalisz gre).
static std::string AssetPath(const std::string &relative) {
    return std::string(GetApplicationDirectory()) + "assets/" + relative;
}

int main() {
    const int screenWidth = 960;
    const int screenHeight = 540;

    InitWindow(screenWidth, screenHeight, "Moja gra - Raylib Template");
    SetTargetFPS(60);

    // Przyklad wczytania grafiki z assets/logo.png (jesli istnieje)
    std::string logoPath = AssetPath("logo.png");
    bool hasLogo = FileExists(logoPath.c_str());
    Texture2D logo{};
    if (hasLogo)
        logo = LoadTexture(logoPath.c_str());

    while (!WindowShouldClose()) {
        BeginDrawing();
        ClearBackground(RAYWHITE);

        if (hasLogo) {
            DrawTexture(logo, screenWidth / 2 - logo.width / 2, 60, WHITE);
        } else {
            DrawText("Wloz wlasne pliki (obrazki, dzwiiiiiieki...) do folderu "
                     "assets/",
                     40, 60, 20, GRAY);
        }

        DrawText(
            "Dodaj nowe pliki .cpp do src/ - CMake wykryje je automatycznie",
            40, screenHeight - 90, 18, DARKGRAY);
        DrawText("Raylib + CMake Template", 40, screenHeight - 60, 20,
                 DARKGRAY);

        EndDrawing();
    }

    if (hasLogo)
        UnloadTexture(logo);

    CloseWindow();
    return 0;
}
