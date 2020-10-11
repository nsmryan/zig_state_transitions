const std = @import("std");
const testing = std.testing;

const StateId = enum {
    First,
    Second,
    Third,
};

const State = struct {
    // internal state just so there is something inside
    internal: u8 = 0,

    comptime id: StateId = .First,

    fn init_private(comptime id: StateId, val: u8) State {
        return State{ .id = id, .internal = val };
    }

    pub fn init(val: u8) State {
        return State.init_private(StateId.First, val);
    }

    fn restate(self: State, comptime new_id: StateId) State {
        return State.init_private(new_id, self.internal);
    }
};

fn first_to_second(state: State) State {
    comptime {
        if (state.id != StateId.First) {
            std.debug.panic("Invalid {}", .{state.id});
        }
    }
    return State.restate(state, .Second);
}

fn second_to_any(state: State) State {
    comptime {
        //std.debug.assert(state.id == StateId.Second);
        if (state.id != StateId.Second) {
            //std.debug.panic("Invalid {}", .{state.id});
            //@panic("Invalid");
        }
    }
    return State.restate(state, .Third);
}

test "test states" {
    var s1 = State.init(2);
    var s2 = first_to_second(s1);

    testing.expect(s1.internal == s2.internal);
    testing.expect(s1.id == StateId.First);
    testing.expect(s2.id == StateId.Second);

    //var s3 = second_to_any(s2);
    //testing.expect(s2.internal == s3.internal);

    //var s4 = second_to_any(s1);
}
