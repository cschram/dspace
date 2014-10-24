import std.stdio;

import dspace.game;

void main() {
    try {
        Game.getInstance().run();
    } catch(Exception e) {
        writeln("Uncaught error, %s, exiting.", e);
    }
}