const std = @import("std");
const rl = @cImport({
    @cInclude("raylib.h");
    @cInclude("raymath.h");
});

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const RndGen = std.rand.DefaultPrng;

    const currentMonitor = rl.GetCurrentMonitor();
    const screenTitle = "DvD logo - written in Zig";
    var screenWidth: i32 = 1920;
    var screenHeight: i32 = 1080;
    try stdout.print("{d}x{d}", .{ screenWidth, screenHeight });

    rl.InitWindow(screenWidth, screenHeight, screenTitle);
    defer rl.CloseWindow();
    screenWidth = rl.GetMonitorWidth(currentMonitor);
    screenHeight = rl.GetMonitorHeight(currentMonitor);
    rl.SetWindowSize(screenWidth, screenHeight);
    rl.ToggleBorderlessWindowed();
    rl.SetWindowPosition(0, 0);

    const logo = rl.LoadTexture("dvd_logo.png");
    defer rl.UnloadTexture(logo);

    const seed = @as(u64, @bitCast(std.time.milliTimestamp()));

    var rnd = RndGen.init(seed);
    var pos = rl.Vector2{
        .x = @floatFromInt(@rem(rnd.random().int(i32), screenWidth)),
        .y = @floatFromInt(@rem(rnd.random().int(i32), screenHeight)),
    };

    const speed = rl.Vector2{ .x = 100.0, .y = 100.0 };
    const size = rl.Vector2{
        .x = @floatFromInt(logo.width),
        .y = @floatFromInt(logo.height),
    };

    const scale: f32 = 0.5;

    var dir = rl.Vector2{
        .x = @floatFromInt(1 - 2 * @mod(rnd.random().int(i32), 2)),
        .y = @floatFromInt(1 - 2 * @mod(rnd.random().int(i32), 2)),
    };

    const colors = [7]rl.Color{
        rl.Color{ .r = 255, .g = 0, .b = 0, .a = 255 }, // red
        rl.Color{ .r = 255, .g = 165, .b = 0, .a = 255 }, // orange
        rl.Color{ .r = 255, .g = 255, .b = 0, .a = 255 }, // yellow
        rl.Color{ .r = 0, .g = 255, .b = 0, .a = 255 }, // green
        rl.Color{ .r = 0, .g = 0, .b = 255, .a = 255 }, // blue
        rl.Color{ .r = 75, .g = 0, .b = 130, .a = 255 }, // indigo
        rl.Color{ .r = 238, .g = 130, .b = 238, .a = 255 }, // violet
    };

    const color_speed: f32 = 0.1;

    var current_color: usize = 0;
    var t: f32 = 0.0;
    rl.SetTargetFPS(rl.GetMonitorRefreshRate(currentMonitor));
    while (!rl.WindowShouldClose()) {
        if (!rl.IsWindowFocused()) continue;
        const dt: f32 = rl.GetFrameTime();
        const c1 = colors[@mod(current_color, 7)];
        const c2 = colors[@mod(current_color + 1, 7)];
        const v1: rl.Vector4 = rl.ColorNormalize(c1);
        const v2: rl.Vector4 = rl.ColorNormalize(c2);
        const v3: rl.Vector4 = rl.Vector4Lerp(v1, v2, t);
        const c3: rl.Color = rl.ColorFromNormalized(v3);

        t += dt * color_speed;
        if (t > 1.0) {
            t = 0.0;
            current_color += 1;
        }
        pos.x += speed.x * dt * dir.x;
        pos.y += speed.y * dt * dir.y;

        if ((pos.x + size.x * scale) > @as(f32, @floatFromInt(screenWidth))) {
            pos.x = @as(f32, @floatFromInt(screenWidth)) - size.x * scale - speed.x * dt;
            dir.x = -1.0;
        }
        if ((pos.y + size.y * scale) > @as(f32, @floatFromInt(screenHeight))) {
            pos.y = @as(f32, @floatFromInt(screenHeight)) - size.y * scale - speed.y * dt;
            dir.y = -1.0;
        }
        if (pos.x < 0.0) {
            pos.x = speed.x * dt;
            dir.x = 1.0;
        }
        if (pos.y < 0.0) {
            pos.y = speed.y * dt;
            dir.y = 1.0;
        }

        const fseconds = rl.GetTime();
        const useconds = @as(u32, @intFromFloat(fseconds));
        const milliseconds: i32 = @intFromFloat((fseconds - @as(f64, @floatFromInt(useconds))) * 100.0);
        const seconds = @mod(useconds, 60);
        const minutes = @mod(useconds / 60, 60);
        const hours = useconds / 3600;

        rl.BeginDrawing();
        defer rl.EndDrawing();

        rl.ClearBackground(rl.BLACK);
        rl.DrawText(rl.TextFormat("%d:%d:%d.%2d", hours, minutes, seconds, milliseconds), 0, 0, 32, c3);
        rl.DrawTextureEx(logo, pos, 0.0, scale, c3);
    }
}
