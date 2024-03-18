const std = @import("std");

const ray = @cImport({
    @cInclude("raylib.h");
});

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const screenWidth = 800;
    const screenHeight = 450;

    const text: [*c]const u8 = "Congrats! You created your first window!";
    const text_fontsize = 20;

    var text_x: f32 = 0;
    var text_y: f32 = 0;

    var speed_x: f32 = 100;
    var speed_y: f32 = 0;

    ray.InitWindow(screenWidth, screenHeight, "ray-zig");

    const font_pixelify_medium: ray.Font = ray.LoadFontEx("res/fonts/PixelifySans-Medium.ttf", 32, 0, 250);
    const font_pixelify_bold: ray.Font = ray.LoadFontEx("res/fonts/PixelifySans-Bold.ttf", 32, 0, 250);

    const text_rect = ray.MeasureTextEx(font_pixelify_medium, text, text_fontsize, 0);

    var fps_history = [_]f32{0} ** 100;
    var fps_history_i: usize = 0;

    const target = ray.LoadRenderTexture(@intFromFloat(text_rect.x), @intFromFloat(text_rect.y));

    ray.BeginTextureMode(target);
    ray.ClearBackground(ray.BLANK);
    ray.DrawTextEx(font_pixelify_medium, text, ray.Vector2{ .x = 0, .y = 0 }, text_fontsize, 0, ray.BLUE);
    ray.EndTextureMode();

    const scale_x: f32 = 1;
    const scale_y: f32 = 1;

    const m: f32 = 20;
    const g: f32 = 9.81;

    while (!ray.WindowShouldClose()) {
        const dt = ray.GetFrameTime();

        fps_history[fps_history_i] = 1 / dt;
        fps_history_i = (fps_history_i + 1) % fps_history.len;

        var avg_fps: f32 = 0;
        for (fps_history) |fps| {
            avg_fps += fps;
        }
        avg_fps /= fps_history.len;

        const fps_string = try std.fmt.allocPrint(allocator, "{d:.0} fps", .{avg_fps});

        speed_y += m * g * dt;

        const dx = speed_x * dt;
        const dy = speed_y * dt;

        if (text_x + dx > screenWidth - text_rect.x * scale_x) {
            text_x = screenWidth - text_rect.x * scale_x;
            speed_x *= -1;
        } else if (text_x + dx < 0) {
            text_x = 0;
            speed_x *= -1;
        }

        if (text_y + dy > screenHeight - text_rect.y * scale_y) {
            text_y = screenHeight - text_rect.y * scale_y;
            speed_y *= -1;
        } else if (text_y + dy < 0) {
            text_y = 0;
            speed_y *= -1;
        }

        text_x += dx;
        text_y += dy;

        const fps_string_rect = ray.MeasureTextEx(font_pixelify_bold, fps_string.ptr, 12, 2);

        ray.BeginDrawing();

        ray.ClearBackground(ray.RAYWHITE);

        const sourceRec = ray.Rectangle{ .x = 0.0, .y = 0.0, .width = @floatFromInt(target.texture.width), .height = @floatFromInt(-target.texture.height) };
        const destRec = ray.Rectangle{ .x = text_x, .y = text_y, .width = @as(f32, @floatFromInt(target.texture.width)) * scale_x, .height = @as(f32, @floatFromInt(target.texture.height)) * scale_y };
        const origin = ray.Vector2{ .x = 0.0, .y = 0.0 };
        ray.DrawTexturePro(target.texture, sourceRec, destRec, origin, 0.0, ray.WHITE);

        ray.DrawTextEx(font_pixelify_bold, fps_string.ptr, ray.Vector2{ .x = screenWidth - fps_string_rect.x - 10, .y = 10 }, 14, 0, ray.DARKGRAY);

        ray.EndDrawing();

        _ = arena.reset(.retain_capacity);
    }

    ray.CloseWindow();
}
