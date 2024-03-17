const std = @import("std");

const ray = @cImport({
    @cInclude("raylib.h");
});

pub fn main() !void {
    const screenWidth = 800;
    const screenHeight = 450;

    const text: [*c]const u8 = "Congrats! You created your first window!";
    const text_fontsize = 20;
    const text_spacing = 2;

    var text_x: f32 = 0;
    var text_y: f32 = 0;

    var dx: f32 = 2;
    var dy: f32 = 2;

    ray.InitWindow(screenWidth, screenHeight, "raylib [core] example - basic window");

    ray.SetTargetFPS(60);

    const text_rect = ray.MeasureTextEx(ray.GetFontDefault(), text, text_fontsize, text_spacing);

    while (!ray.WindowShouldClose()) {
        if (text_x + dx > screenWidth - text_rect.x) {
            text_x = screenWidth - text_rect.x;
            dx *= -1;
        } else if (text_x + dx < 0) {
            text_x = 0;
            dx *= -1;
        }

        if (text_y + dy > screenHeight - text_rect.y) {
            text_y = screenHeight - text_rect.y;
            dy *= -1;
        } else if (text_y + dy < 0) {
            text_y = 0;
            dy *= -1;
        }

        text_x += dx;
        text_y += dy;

        ray.BeginDrawing();

        ray.ClearBackground(ray.RAYWHITE);

        ray.DrawTextEx(ray.GetFontDefault(), text, ray.Vector2{ .x = text_x, .y = text_y }, text_fontsize, text_spacing, ray.RED);

        ray.EndDrawing();
    }

    ray.CloseWindow();
}
