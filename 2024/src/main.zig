const std = @import("std");
const day1 = @import("day1.zig");
const day2 = @import("day2.zig");

pub fn main() anyerror!void {
    // std.debug.print("Day 1\n", .{});
    // try day1.part1("../input/day1/input.txt");
    // try day1.part2("../input/day1/input.txt");

    std.debug.print("Day 2\n", .{});
    try day2.part1("../input/day2/input.txt");
    try day2.part2("../input/day2/input.txt");
}
