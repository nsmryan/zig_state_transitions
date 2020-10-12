const std = @import("std");
const testing = std.testing;

const State = struct {
    comptime id: bool = true,

    pub fn init(comptime id: bool) State {
        return State{ .id = id };
    }
};

test "test states" {
    var s1 = State.init(true);
    testing.expect(s1.id == true);

    var s2 = State.init(false);
    testing.expect(s2.id == false);
}
