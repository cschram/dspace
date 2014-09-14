import std.stdio;

import dspace.game;

void main() {
    writeln("Starting Game...");
    Game.getInstance().run();
    writeln("Exiting...");
}