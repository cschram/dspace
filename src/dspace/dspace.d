module dspace.dspace;

import std.format;
import std.stdio;

import dsfml.graphics;

import engine.game;

class DSpace : Game
{
    override protected void configure()
    {
        window = new RenderWindow(VideoMode(800, 600), "DSpace");
        window.setFramerateLimit(60);
    }
}