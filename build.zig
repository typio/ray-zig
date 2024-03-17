const raylib = @import("deps/raylib/src/build.zig");
const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});

    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "ray-zig",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    const ray = try raylib.addRaylib(b, target, optimize, .{});
    exe.linkLibrary(ray);
    exe.addIncludePath(.{ .path = "deps/raylib/src" });

    b.installArtifact(exe);

    // Build for multiple targets (disabled bc I don't have env set up for it)
    // const targets: []const std.Target.Query = &.{
    //     .{ .cpu_arch = .x86_64, .os_tag = .macos },
    //     .{ .cpu_arch = .aarch64, .os_tag = .linux },
    //     .{
    //         .cpu_arch = .x86_64,
    //         .os_tag = .linux,
    //     },
    //     .{ .cpu_arch = .x86_64, .os_tag = .windows },
    // };
    //
    // const optimize = b.standardOptimizeOption(.{});
    //
    // for (targets) |t| {
    //     const exe = b.addExecutable(.{
    //         .name = "ray-zig",
    //         .root_source_file = .{ .path = "src/main.zig" },
    //         .target = b.resolveTargetQuery(t),
    //         .optimize = .ReleaseFast,
    //     });
    //
    //     const ray = try raylib.addRaylib(b, b.resolveTargetQuery(t), optimize, .{});
    //     exe.linkLibrary(ray);
    //     exe.addIncludePath(.{ .path = "deps/raylib/src" });
    //
    //     const target_output = b.addInstallArtifact(exe, .{
    //         .dest_dir = .{
    //             .override = .{
    //                 .custom = try t.zigTriple(b.allocator),
    //             },
    //         },
    //     });
    //
    //     b.getInstallStep().dependOn(&target_output.step);
    // }
}
