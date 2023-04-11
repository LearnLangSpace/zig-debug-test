const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});

    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(std.Build.ExecutableOptions{
        .name = "zig-debug-test",
        .target = target,
        .optimize = optimize,
        .root_source_file = .{
            .path = "src/main.zig",
        },
    });
    exe.install();

    const run_cmd = exe.run();
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const test_step = b.step("test", "Run unit tests");

    var exe_tests = b.addTest(std.Build.TestOptions{
        .name = "main-test",
        .root_source_file = .{
            .path = "src/main.zig",
        },
        .target = target,
        .optimize = optimize,
    });
    test_step.dependOn(&exe_tests.step);

    exe_tests = b.addTest(std.Build.TestOptions{
        .name = "introducing_zig",
        .root_source_file = .{
            .path = "src/introducing_zig.zig",
        },
        .target = target,
        .optimize = optimize,
    });
    test_step.dependOn(&exe_tests.step);

    exe_tests = b.addTest(std.Build.TestOptions{
        .name = "new_test",
        .root_source_file = .{
            .path = "src/new_test.zig",
        },
        .target = target,
        .optimize = optimize,
    });
    test_step.dependOn(&exe_tests.step);
}
