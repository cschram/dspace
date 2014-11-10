module dspace.core.game;

import std.stdio;
import std.algorithm;
import std.signals;

import artemisd.all;
import dsfml.graphics;
import dsfml.audio;

import dspace.components.dimensions;
import dspace.components.enemystate;
import dspace.components.playerstate;
import dspace.components.renderer;
import dspace.components.velocity;
import dspace.core.resourcemgr;
import dspace.core.statemachine;
import dspace.states.gamestate;
import dspace.states.game.gameover;
import dspace.states.game.playing;
import dspace.states.game.startmenu;
import dspace.systems.animation;
import dspace.systems.movement;
import dspace.systems.render;

/*****************************************************************************
 * Game Event
 * Contains all possible information needed for signals emitted by the Game
 * Singleton.
 ****************************************************************************/
struct GameEvent
{
    enum EventType
    {
        STAGE_UPDATE = 0,
        KEY_PRESSED  = 1,
        EXITING      = 2
    }

    enum LoopStage
    {
        UPDATE            = 0,
        RENDER_BACKGROUND = 1,
        RENDER_UI         = 2
    }

    EventType    type;
    LoopStage    loopStage;
    float        delta;
    RenderWindow renderWindow;
    Keyboard.Key keyCode;
}

/******************************************************************************
 * Game Singleton
 * Responsible for core game logic (main loop) and global data.
 *****************************************************************************/
class Game
{

    mixin Signal!(GameEvent);

    /**************************************************************************
     * Private State
     *************************************************************************/

    private __gshared Game _instance;
    private static    bool _instantiated;

    private RenderWindow    window;
    private ResourceManager resourceMgr;
    private StateMachine    states;
    private World           world;
    private TagManager      worldTagMgr;
    private Entity          player;
    private Clock           clock;

    private Sprite          background;
    private float           backgroundPosition = 1000;
    private bool            scrolling          = false;

    /**************************************************************************
     * Public State

     *************************************************************************/

     /**
      * Constants
      */
    static immutable(VideoMode) screenMode    = VideoMode(400, 600);
    static immutable(short)     scrollSpeed   = 30;
    static immutable(float)     cacheInterval = 1.0f;

    int score;

    /**************************************************************************
     * Private Methods
     *************************************************************************/

    private this()
    {
        resourceMgr = new ResourceManager;
        states = new StateMachine;
        clock = new Clock;
        background = resourceMgr.getSprite("images/background.png");
        background.textureRect = IntRect(0, cast(int)backgroundPosition, 400, 600);
    }

    private void pollEvents()
    {
        Event e;
        while (window.pollEvent(e)) {
            switch (e.type) {
                case e.EventType.Closed:
                    close();
                    break;

                case e.EventType.KeyPressed:
                    GameEvent evt;
                    evt.type = GameEvent.EventType.KEY_PRESSED;
                    evt.keyCode = e.key.code;
                    emit(evt);

                    if (e.key.code == Keyboard.Key.Escape) {
                        window.close();
                    }
                    break;

                default: break;
            }
        }
    }

    private void update(float delta)
    {
        if (scrolling) {
            backgroundPosition -= scrollSpeed * delta;
            auto rect = background.textureRect;
            rect.top = cast(int)backgroundPosition;
            background.textureRect = rect;
            scrolling = (backgroundPosition > 0);
        }

        GameEvent e;
        e.type = GameEvent.EventType.STAGE_UPDATE;
        e.loopStage = GameEvent.LoopStage.UPDATE;
        e.delta = delta;
        emit(e);

        world.setDelta(delta);
        world.process();
    }

    /**************************************************************************
     * Static Methods
     *************************************************************************/

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

    static ResourceManager getResourceMgr()
    {
        return _instance.resourceMgr;
    }

    /**************************************************************************
     * Public Methods
     *************************************************************************/

     void renderBackground()
     {
        window.draw(background);

        GameEvent e;
        e.type = GameEvent.EventType.STAGE_UPDATE;
        e.loopStage = GameEvent.LoopStage.RENDER_BACKGROUND;
        e.renderWindow = window;
        emit(e);
     }

     void renderUI()
     {
        GameEvent e;
        e.type = GameEvent.EventType.STAGE_UPDATE;
        e.loopStage = GameEvent.LoopStage.RENDER_UI;
        e.renderWindow = window;
        emit(e);
     }

    /**
     * Getters / Access
     */

    RenderWindow getWindow()
    {
        return window;
    }

    World getWorld()
    {
        return world;
    }

    TagManager getTagMgr()
    {
        return worldTagMgr;
    }

    Entity getPlayer()
    {
        return player;
    }

    Entity getTaggedEntity(const(string) name)
    {
        return worldTagMgr.getEntity(name);
    }

    bool hasStarted() const
    {
        if (states.getCurrentStateName() == "playing") {
            return true;
        }
        return false;
    }

    /**
     * Setters / Mutate State
     */

    void startScrolling()
    {
        scrolling = true;
        backgroundPosition = 1000;
    }

    void close()
    {
        GameEvent e;
        e.type = GameEvent.EventType.EXITING;
        emit(e);
        window.close();
    }

    /**
     * Main Loop
     */
    void run()
    {
        writeln("Creating window...");
        window = new RenderWindow(screenMode, "DSpace");
        window.setFramerateLimit(60);

        writeln("Creating world...");
        world = new World;
        world.setSystem(new MovementSystem(this));
        world.setSystem(new AnimationSystem(this));
        world.setSystem(new RenderSystem(this));
        worldTagMgr = new TagManager;
        world.setManager(worldTagMgr);
        world.initialize();

        player = world.createEntity();
        player.addComponent(new Dimensions(Vector2f(172.5, 539), Vector2f(55, 61)));
        player.addComponent(new PlayerState);
        player.addComponent(new Renderer(resourceMgr.getAnimationSet("anim/player.animset")));
        player.addComponent(new Velocity(Vector2f(0.0f, 0.0f), true));
        player.addToWorld();
        player.disable();
        worldTagMgr.register("player", player);

        states.addState(new StartMenuState(this));
        states.addState(new PlayingState(this));
        states.addState(new GameOverState(this));

        if (!states.transitionTo("startmenu")) {
            writeln("Unable to transition to Start Menu, closing...");
            close();
        }

        clock.restart();
        float delta = 0.0f;
        float cacheTimer = 1.0f;
        writeln("Starting...");
        while (window.isOpen()) {
            cacheTimer -= delta;
            if (cacheTimer <= 0.0f) {
                resourceMgr.collect(delta);
                cacheTimer = 1.0f;
            }

            pollEvents();
            update(delta);

            delta = clock.getElapsedTime().asSeconds();
            clock.restart();
        }
    }

}