import std.stdio;

import dspace.game;

void main() {
    try {
        Game.getInstance().run();
    } catch(Exception e) {
        writeln("Uncatch error, %s, exiting.", e);
    }
}