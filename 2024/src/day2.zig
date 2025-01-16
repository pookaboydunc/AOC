const std = @import("std");
const helpers = @import("helpers.zig");

pub fn part1(path: []const u8) !void {
    // Open the file
    const file = try helpers.openFile(path);
    defer file.close();
    const total: i32 = try processFile(file, false);
    std.debug.print("Part1 Total: {d}\n", .{total});
}

pub fn part2(path: []const u8) !void {
    // Open the file
    const file = try helpers.openFile(path);
    defer file.close();
    const total: i32 = try processFile(file, true);
    std.debug.print("Part2 End Total: {d}\n", .{total});
}

fn processFile(file: std.fs.File, dampner: bool) !i32 {
    //  Get an allocator
    var gp = std.heap.GeneralPurposeAllocator(.{ .safety = true }){};
    defer _ = gp.deinit();
    const allocator = gp.allocator();

    var buffered = std.io.bufferedReader(file.reader());
    var reader = buffered.reader();

    var line_buffer = std.ArrayList(u8).init(allocator);
    defer line_buffer.deinit();
    var total: i32 = 0;
    while (true) {
        reader.streamUntilDelimiter(line_buffer.writer(), '\n', null) catch |err| switch (err) {
            error.EndOfStream => {
                if (line_buffer.items.len > 0) {
                    // Process the last line
                    total += try processLine(line_buffer.items, dampner);
                    std.debug.print("Total: {d}\n", .{total});
                }
                break;
            },
            else => return err,
        };

        total += try processLine(line_buffer.items, dampner);
        //std.debug.print("Total: {d}\n", .{total});
        line_buffer.clearRetainingCapacity();
    }
    return total;
}

fn processLine(line: []const u8, dampner: bool) !i32 {
    //std.debug.print("dampner: {}\n", .{dampner});
    //  Get an allocator
    var gp = std.heap.GeneralPurposeAllocator(.{ .safety = true }){};
    defer _ = gp.deinit();
    const allocator = gp.allocator();
    const safe = safeLine(line, allocator, dampner) catch false;
    if (!safe) {
        return 0;
    }
    return 1;
}

fn safeLine(line: []const u8, allocator: std.mem.Allocator, dampner: bool) !bool {
    var remove: bool = true;
    var asc = false;
    var desc = false;
    var list = std.ArrayList(i64).init(allocator);
    defer list.deinit();
    var it = std.mem.tokenizeScalar(u8, line, ' ');
    var previous: i32 = 0;
    if (it.next()) |token| {
        previous = try std.fmt.parseInt(i32, token, 10);
        try list.append(previous);
    }

    while (it.next()) |token| {
        const num = try std.fmt.parseInt(i32, token, 10);
        const diff: u32 = @abs(num - previous);
        //std.debug.print("{d}=>{d} = {d} diff\n", .{ previous, num, diff });
        if ((diff > 3) or (diff < 1)) {
            if (remove and dampner) {
                remove = false;
                continue;
            }
            //std.debug.print("line check diff: {d}, num: {d}, previous: {d} for this line --> {any}\n", .{ diff, num, previous, list.items });
            return false;
        }
        if (num > previous) {
            if (desc) {
                if (remove and dampner) {
                    remove = false;
                    previous = num;
                    continue;
                }
                return false;
            }
            asc = true;
        }
        if (num < previous) {
            if (asc) {
                if (remove and dampner) {
                    remove = false;
                    previous = num;
                    continue;
                }
                return false;
            }
            desc = true;
        }
        try list.append(num);
        previous = num;
    }
    // const asc = try allocator.dupe(i64, list.items);
    // defer allocator.free(asc);
    // const desc = try allocator.dupe(i64, list.items);
    // defer allocator.free(desc);
    // // sort the elements
    // std.sort.heap(i64, asc, {}, std.sort.asc(i64));
    // std.sort.heap(i64, desc, {}, std.sort.desc(i64));

    // if (!std.mem.eql(i64, list.items, asc)) {
    //     if (!std.mem.eql(i64, list.items, desc)) {
    //         std.debug.print("line check does not equal asc: {any} or desc: {any}\n", .{ asc, desc });
    //         return false;
    //     }
    // }
    return true;
}
