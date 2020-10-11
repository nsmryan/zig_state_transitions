This repo is an attempt to use Zig's comptime mechanism to implement type checked
(or, at least comptime checked) state transitions.


The idea is that you have a type that represents you libraries state, and the
functions you define are only allowed on certain transitions. This could be used,
for example, to ensure that a socket's accept function is only called on a socket
after bind is called, or other such invariants.


I attempted this four times, and I will write up each attempt briefly 
for future reference.



## first\_attempt.zig (Enum Type Parameters)
I found that the only way I can get this to happen successfully in Zig right
now is through type parameters. 


Zig's comptime can be use similar to a
dependent type system, so you can parameterized a structure's type by the value
of an enum, and then write functions that only work for structs with a
particular value.


The limitation here is that the output of a particular function must have one
and only one state- there is no way to say that the function returns any state,
or one of two states. Looking over the standard liraries 'meta' code in the Zig
source shows that the language appears to have some kind of type switching that
might be used to return of several possible types, but there is currently
no documentation for this feature.


## second\_attempt.zig (Type as a Parameter)
I attempted to add the type as a parameter as well as the value indicating the
state. The hope was that I could say "the return value is a State structure parameterized
by a value of this known type". However, there is no way to say this in the return position
of a function. The return values have to be comptime known. This is when I started to realize
that this may be a rank-N type situation where I am attempting to bind a variable after the
functoin arrow and failing.


## third\_attempt.zig (Types for Types)
I then tried to avoid using the enum by splitting its variants into separate types. The
State struct is then parameterized by a type. This does not help at all. I thought maybe
I could use anytype, but that appears to only work in arguments? I couldn't get it to
work.


## fourth\_attempt.zig
This was an interesting one. I thought I might be able to hide the type information inside
the structure, keeping it from appearing in the type at all. Then, I would just have to
add comptime block with assertions to enforce type invariants for state transitions.


This would not be the nice type theory solution, but it seemed Ziggy enough to me.
It would work, and be somewhat manual, but that seems fine for a language that is not
focused on theory but on engineering.


Sadly this also did not work. I added a comptime parameter called 'id' and tried to
set it to different value. Strangely you can create a structure with different values
for a comptime field, but the values are not actually used. The comptime field
will not compile without a default value, and this value is used whether or not you
set one when initializing the struct.


I made [issue 6656](https://github.com/ziglang/zig/issues/6656) asking if this should
work or not, and pointing out that the value appears to be set, and compiles, but that the
comptime field does not use this value. We will see how the issue plays out, but I am
leaving this repo as-is for now until another solution presents itself.


## Conclusion
As far as I can tell, the way to enforce state transitions in Zig right now would be to
define an enum of states, parameterize your types with values from this enum, and define
function that enforce certain inputs and outputs. There does not appear to be any 
way to make this more flexible, which might be fine after all- I can't think of an
actual case right now where the return types needs to be more generic. In the
future the type switching that appears in the Zig source code might be applicable, but I
truely don't know.





