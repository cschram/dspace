module dspace.dspace;

import dsfml.graphics;

import engine.game;

class DSpace : Game
{
    override protected void initWindow()
    {
        window = new RenderWindow(VideoMode(800, 600), "DSpace");
        window.setFramerateLimit(60);
    }
}