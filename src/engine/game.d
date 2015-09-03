module engine.game;

import std.stdio;
import std.signals;

import dsfml.graphics;

import engine.resourcemgr;
import engine.statemgr;

abstract class Game
{
    protected StateManager stateMgr;
    protected RenderWindow window;

    this()
    {
        stateMgr = new StateManager();
        configure();
    }

    protected void configure()
    {
        window = new RenderWindow(VideoMode(800, 600), "D Game Engine");
        window.setFramerateLimit(60);
    }

    protected void pollEvents()
    {
        Event e;
        while (window.pollEvent(e)) {
            switch (e.type) {
                case e.EventType.Closed:
                    close();
                    break;

                default: break;
            }
        }
    }

    void close()
    {
        debug writeln("Closing...");
        window.close();
    }

    void run()
    {
        Clock clock = new Clock();
        float delta = 0.0f;
        float cacheTimer = 1.0f;

        initWindow();

        debug writeln("Starting...");
        while (window.isOpen()) {
            cacheTimer -= delta;
            if (cacheTimer <= 0.0f) {
                ResourceManager.collect(delta);
                cacheTimer = 1.0f;
            }

            pollEvents();

            delta = clock.getElapsedTime().asSeconds();
            clock.restart();
        }
    }
}