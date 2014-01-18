import std.stdio;

import game;

void main() {
	writeln("Starting Game...");
    Game.GetInstance().Run();
    writeln("Exiting...");
}