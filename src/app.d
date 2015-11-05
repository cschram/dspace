import etc.linux.memoryerror;

import dspace.dspace;

shared static this() {
    static if (is(typeof(registerMemoryErrorHandler))) {
        registerMemoryErrorHandler();
    }
}

void main()
{
    version(unittest) {
        import std.stdio;
        writeln("Unit tests successful.");
        return;
    }

    auto game = new DSpace();
    game.run();
}