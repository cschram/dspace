module engine.game;

debug import std.stdio;

import dsfml.graphics;

import engine.resourcemgr;
import engine.states.idle;
import engine.states.manager;

abstract class Game
{
    //
    // Configuration options
    //
    protected VideoMode cfgVideoMode      = VideoMode(800, 600);
    protected string    cfgWindowTitle    = "D Game Engine";
    protected uint      cfgFramerateLimit = 60;

    //
    // Internal state
    //
    protected StateManager stateMgr;
    protected RenderWindow window;

    this()
    {
        stateMgr = new StateManager();
        configure();
        window = new RenderWindow(cfgVideoMode, cfgWindowTitle);
        window.setFramerateLimit(cfgFramerateLimit);
        setupStates();
    }

    // Modify configuration options
    protected void configure();

    // Setup main game states
    protected void setupStates()
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

    final RenderWindow getWindow()
    {
        return window;
    }

    final bool setState(string state)
    {
        return stateMgr.setState(state);
    }

    final void close()
    {
        debug writeln("Closing...");
        window.close();
    }

    final void run()
    {
        Clock clock      = new Clock();
        float delta      = 0;
        float cacheTimer = 1;

        debug writeln("Starting...");
        while (window.isOpen()) {
            cacheTimer -= delta;
            if (cacheTimer <= 0) {
                ResourceManager.collect(delta);
                cacheTimer = 1;
            }

            pollEvents();
            stateMgr.getState().update(delta);

            delta = clock.getElapsedTime().asSeconds();
            clock.restart();
        }
    }
}