const std = @import("std");
const testing = std.testing;

const First = Opaque;
const Second = Opaque;
const Third = Opaque;

fn State(comptime typ: type) type {
    return struct {
        // internal state just so there is something inside
        internal: u8 = 0,

        const Self = State(typ);

        pub fn init(val: u8) Self {
            return State(id){ .internal = val };
        }

        // change state with a pointer cast
        pub fn restate(self: *Self, comptime new_typ: type) *State(new_id) {
            return @ptrCast(*State(new_id), self);
        }

        // change state with a bit cast
        pub fn restate2(self: Self, comptime new_id: type) State(new_id) {
            return @bitCast(State(new_id), self);
        }
    };
}

fn first_to_string(state: *State(First)) *State(Second) {
    return State(First).restate(state, Second);
}

fn second_to_third(comptime state_id: type, state: *State(Second)) *State(Third) {
    return State(StateId, .Second).restate2(state, StateId.Third);
}

fn second_to_any(state: *State(Second)) *State(anytype) {
    return State(.Second).restate(state, Third);
}

test "test states" {
    var s1 = State(StateId, First).init(2);
    var s2 = first_to_string(&s1);

    testing.expect(s1.internal == s2.internal);

    var s3 = second_to_any(StateId, s2);
    testing.expect(s2.internal == s3.internal);
}
