const std = @import("std");
const testing = std.testing;

pub const StateId = enum {
    First,
    Second,
    Third,
};

pub const Input = enum {
    I0,
    I1,
};

pub fn State(id: StateId) type {
    return struct {
        val: u8,

        id: StateId,

        const InitState = State(.First);

        pub fn init(val: u8) InitState {
            return InitState{ .val = val, .id = .First };
        }
    };
}

pub fn restate(comptime old_id: StateId, state: State(old_id), comptime input: Input) State(state_trans(input, old_id)) {
    return State(state_trans(input, old_id));
}

fn state_trans(comptime input: Input, comptime id: StateId) StateId {
    return switch (id) {
        .First => .Second,
        .Second => .Third,
        .Third => .First,
    };
}

pub fn first_to_second(state: State(.First)) State(state_trans(Input.I0, .First)) {
    return restate(.First, state, Input.I0);
}

test "test states" {
    var s1 = State(.First).init(2);
    testing.expect(s1.val == 2);

    var s2 = first_to_second(s1);
    testing.expect(s2.val == 2);
}
