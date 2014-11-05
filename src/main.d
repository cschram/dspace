import std.stdio;

import dspace.core.game;

void main() {
    try {
        Game.getInstance().run();
    } catch(Exception e) {
        writeln("Uncaught error, %s, exiting.", e);
    }
}