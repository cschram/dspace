module engine.game;

import std.stdio;

import dsfml.graphics;

import engine.resourcemgr;
import engine.states.idle;
import engine.states.manager;

abstract class Game
{
    protected StateManager stateMgr;
    protected RenderWindow window;

    this()
    {
        stateMgr = new StateManager();

        initWindow();
        configure();
    }

    protected void initWindow()
    {
        window = new RenderWindow(VideoMode(800, 600), "D Game Engine");
        window.setFramerateLimit(60);
    }

    protected void configure()
    {
        stateMgr.addState("idle", new IdleState(window));
    }

    protected void pollEvents()
    {
        auto state = stateMgr.getState();
        Event e;
        while (window.pollEvent(e)) {
            switch (e.type) {
                case e.EventType.Closed:
                    close();
                    break;

                default: break;
            }
            state.handleInput(e);
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

        debug writeln("Starting...");
        while (window.isOpen()) {
            cacheTimer -= delta;
            if (cacheTimer <= 0.0f) {
                ResourceManager.collect(delta);
                cacheTimer = 1.0f;
            }

            pollEvents();
            stateMgr.getState().update(delta);

            delta = clock.getElapsedTime().asSeconds();
            clock.restart();
        }
    }
}