const std = @import("std");
const helpers = @import("helpers.zig");

pub fn part1(path: []const u8) !void {
    //  Get an allocator
    var gp = std.heap.GeneralPurposeAllocator(.{ .safety = true }){};
    defer _ = gp.deinit();
    const allocator = gp.allocator();

    // define the left and right arrays
    var left = std.ArrayList(i64).init(allocator);
    defer left.deinit();
    var right = std.ArrayList(i64).init(allocator);
    defer right.deinit();

    // Open the file
    const file = try helpers.openFile(path);
    defer file.close();

    try processFile(file, &left, &right);
    const total: u64 = try calculateTotalDistance(&left, &right);

    std.debug.print("Part1 Total: {d}\n", .{total});
}

pub fn part2(path: []const u8) !void {
    //  Get an allocator
    var gp = std.heap.GeneralPurposeAllocator(.{ .safety = true }){};
    defer _ = gp.deinit();
    const allocator = gp.allocator();

    // define the left and right arrays
    var left = std.ArrayList(i64).init(allocator);
    defer left.deinit();
    var right = std.ArrayList(i64).init(allocator);
    defer right.deinit();

    // Open the file
    const file = try helpers.openFile(path);
    defer file.close();

    try processFile(file, &left, &right);
    var map = std.AutoHashMap(i64, i64).init(
        allocator,
    );
    defer map.deinit();
    var total: i64 = 0;
    for (right.items) |v| {
        const old = try map.fetchPut(v, 1);
        if (old == null) {
            try map.put(v, 1);
            continue;
        }
        const new: i64 = old.?.value + 1;
        try map.put(v, new);
    }
    for (left.items) |v| {
        const r = map.get(v);
        if (r) |value| {
            total += v * value;
        }
    }
    std.debug.print("Part2 Total: {d}\n", .{total});
}

fn processFile(file: std.fs.File, left: *std.ArrayList(i64), right: *std.ArrayList(i64)) !void {
    //  Get an allocator
    var gp = std.heap.GeneralPurposeAllocator(.{ .safety = true }){};
    defer _ = gp.deinit();
    const allocator = gp.allocator();

    var buffered = std.io.bufferedReader(file.reader());
    var reader = buffered.reader();

    var line_buffer = std.ArrayList(u8).init(allocator);
    defer line_buffer.deinit();

    while (true) {
        reader.streamUntilDelimiter(line_buffer.writer(), '\n', null) catch |err| switch (err) {
            error.EndOfStream => {
                if (line_buffer.items.len > 0) {
                    // Process the last line
                    try processLine(line_buffer.items, left, right);
                }
                break;
            },
            else => return err,
        };

        try processLine(line_buffer.items, left, right);
        line_buffer.clearRetainingCapacity();
    }
    // sort the elements
    std.sort.heap(i64, left.items, {}, std.sort.asc(i64));
    std.sort.heap(i64, right.items, {}, std.sort.asc(i64));
}

fn processLine(line: []const u8, left: *std.ArrayList(i64), right: *std.ArrayList(i64)) !void {
    var split = std.mem.split(u8, line, "   ");
    if (split.next()) |first| {
        const firstVal = try std.fmt.parseInt(i64, first, 10);
        try left.append(firstVal);
    }
    if (split.next()) |second| {
        const secondVal = try std.fmt.parseInt(i64, second, 10);
        try right.append(secondVal);
    }
}

fn calculateTotalDistance(left: *std.ArrayList(i64), right: *std.ArrayList(i64)) !u64 {
    var total: u64 = 0;
    // add up the differences
    for (left.items, right.items) |l, r| {
        const t: u64 = @abs(l - r);
        total += t;
    }
    return total;
}
