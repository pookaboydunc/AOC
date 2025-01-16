const std = @import("std");

pub fn openFile(path: []const u8) !std.fs.File {
    // Get the path
    var path_buffer: [std.fs.MAX_PATH_BYTES]u8 = undefined;
    const p = try std.fs.realpath(path, &path_buffer);

    // Open the file
    const file = try std.fs.openFileAbsolute(p, .{ .mode = .read_only });
    return file;
}
