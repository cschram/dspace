module dspace.game;

import std.stdio;
import std.algorithm;

import dsfml.graphics;
import dsfml.audio;

import dspace.resourcemgr;
import dspace.core.statemachine;
import dspace.core.quadtree;

import dspace.states.gamestate;
import dspace.states.game.gameover;
import dspace.states.game.playing;
import dspace.states.game.startmenu;

import dspace.core.entity;
import dspace.entities.player;

class Game
{

    static immutable(VideoMode) screenMode    = VideoMode(400, 600);
    static immutable(short)     scrollSpeed   = 30;
    static immutable(float)     cacheInterval = 1.0f;

    private __gshared Game _instance;
    private static bool _instantiated;

    private RenderWindow    window;
    private ResourceManager resourceMgr;
    private StateMachine    states;
    private Entity[]        entities;
    private Player          player;
    private QuadTree        qtree;
    private Clock           clock;

    private Sprite          background;
    private int             score              = 0;
    private float           backgroundPosition = 1000;
    private bool            scrolling          = false;

    private this()
    {
        resourceMgr = new ResourceManager;
        states = new StateMachine;
        qtree = new QuadTree(0, FloatRect(0, 0, screenMode.width, screenMode.height));
        clock = new Clock;
        background = resourceMgr.getSprite("images/background.png");
        background.textureRect = IntRect(0, cast(int)backgroundPosition, 400, 600);
    }

    private bool update(float delta)
    {
        if (scrolling) {
            backgroundPosition -= scrollSpeed * delta;
            auto rect = background.textureRect;
            rect.top = cast(int)backgroundPosition;
            background.textureRect = rect;
            scrolling = (backgroundPosition > 0);
        }

        return states.update(delta);
    }

    private void render()
    {
        window.clear();
        window.draw(background);
        GameState state = cast(GameState)states.getCurrentState();
        state.render(window);
        window.display();
    }

    static Game getInstance()
    {
        if (!_instantiated) {
            synchronized {
                if (_instance is null) {
                    _instance = new Game;
                }
                _instantiated = true;
            }
        }
        return _instance;
    }

    ResourceManager getResourceMgr()
    {
        return resourceMgr;
    }

    Player getPlayer()
    {
        return player;
    }

    Entity[] getEntities()
    {
        return entities;
    }

    void insertEntity(Entity e)
    {
        entities ~= e;
    }

    bool pollEvent(ref Event e)
    {
        if (window.pollEvent(e)) {
            switch (e.type) {
                case e.EventType.Closed:
                    window.close();
                    break;

                case e.EventType.KeyPressed:
                    if (e.key.code == Keyboard.Key.Escape) {
                        window.close();
                    }
                    break;

                default: break;
            }
            return true;
        }
        return false;
    }

    void startScrolling()
    {
        scrolling = true;
        backgroundPosition = 1000;
    }

    void run()
    {
        states.addState(new StartMenuState);
        states.addState(new PlayingState);
        states.addState(new GameOverState);

        player = new Player(Vector2f(172.5, 539));
        insertEntity(player);

        writeln("Creating window...");
        window = new RenderWindow(screenMode, "DSpace");
        window.setFramerateLimit(60);

        writeln("Starting...");

        if (!states.transitionTo("startmenu")) {
            writeln("Unable to transition to Start Menu, closing...");
            window.close();
        }

        clock.restart();
        float delta = 0.0f;
        float cacheTimer = 0.0f;
        while (window.isOpen()) {
            if (update(delta)) {
                render();

                cacheTimer -= delta;
                if (cacheTimer <= 0.0f) {
                    resourceMgr.collect(delta);
                }
            } else {
                writeln("Closing...");
                window.close();
            }
            delta = clock.getElapsedTime().asSeconds();
            clock.restart();
        }
    }

    bool hasStarted() const
    {
        if (states.getCurrentStateName() == "playing") {
            return true;
        }
        return false;
    }

    public int getScore() const
    {
        return score;
    }

    public void addScore(int amt)
    {
        score += amt;
    }

}