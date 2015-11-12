module engine.game;

debug import std.stdio;

import dsfml.graphics;

import engine.configmgr;
import engine.resourcemgr;
import engine.states.idle;
import engine.states.manager;

enum CACHE_LIFETIME = 1;

abstract class Game
{
    this()
    {
        configure();

        auto config = ConfigManager.get();
        window = new RenderWindow(config.videoMode, config.windowTitle);
        window.setFramerateLimit(config.framerate);

        stateMgr = setupStates();
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
        Clock clock = new Clock();
        float delta = 0;
        float cacheTimer = CACHE_LIFETIME;

        debug writeln("Starting...");
        while (window.isOpen()) {
            cacheTimer -= delta;
            if (cacheTimer <= 0) {
                ResourceManager.collect(delta);
                cacheTimer = CACHE_LIFETIME;
            }

            pollEvents();
            stateMgr.getState().update(delta);

            delta = clock.getElapsedTime().asSeconds();
            clock.restart();
        }
    }

protected:
    // Modify configuration options
    void configure();

    // Setup main game states
    StateManager setupStates()
    {
        auto states = new StateManager();
        states.addState("idle", new IdleState(window));
        return states;
    }

    void pollEvents()
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

private:
    StateManager stateMgr;
    RenderWindow window;
}