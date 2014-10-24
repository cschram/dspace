module dspace.game;

import std.stdio;
import dsfml.graphics;
import dsfml.audio;
import artemisd.all;
import dspace.resources;
import dspace.statemachine;
import dspace.components.dimensions;
import dspace.components.entitysprite;
import dspace.components.entitystate;
import dspace.components.spritesheet;
import dspace.components.velocity;
import dspace.states.game.gameover;
import dspace.states.game.playing;
import dspace.states.game.startmenu;
import dspace.systems.movement;

class Game
{

    //
    // Constants
    //

    static immutable(VideoMode) screenMode = VideoMode(400, 600);

    //
    // Private Variables
    //

    private __gshared Game _instance;
    private static bool _instantiated;

    // State
    private RenderWindow    window;
    private ResourceManager resources;
    private StateMachine    states;
    private World           world;
    private Entity          player;
    private int             score;

    //
    // Private Methods
    //

    private this()
    {
        resources = new ResourceManager;
        states = new StateMachine;
    }

    //
    // Public Methods
    //

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

    RenderWindow getWindow()
    {
        return window;
    }

    ResourceManager getResources()
    {
        return resources;
    }

    World getWorld()
    {
        return world;
    }

    Entity getPlayer()
    {
        return player;
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

    void run()
    {
        writeln("Loading...");

        // Setup window
        writeln("Creating window...");
        window = new RenderWindow(screenMode, "DSpace");
        window.setFramerateLimit(60);

        // Setup world
        writeln("Creating world...");
        world = new World();
        world.setSystem(new MovementSystem);
        auto groupManager = new GroupManager;
        auto tagManager = new TagManager;
        world.setManager(groupManager);
        world.setManager(tagManager);
        world.initialize();

        // Setup player
        writeln("Creating player...");
        player = world.createEntity();
        auto playerSprite = resources.getSprite("images/ship.png");
        player.addComponent(new Dimensions(Vector2f(172.5, 539), Vector2f(55, 61)));
        player.addComponent(new Velocity(true));
        player.addComponent(new EntityState(10));
        player.addComponent(new SpriteSheet(playerSprite, Vector2i(55, 61), 3));
        player.addToWorld();

        // Setup states
        states.addState(new StartMenuState);
        states.addState(new PlayingState);
        states.addState(new GameOverState);

        // Main loop
        writeln("Starting...");

        if (!states.transitionTo("startmenu")) {
            writeln("Unable to transition to Start Menu, closing...");
            window.close();
        }

        while (window.isOpen()) {
            if (!states.update()) {
                writeln("Closing...");
                window.close();
            }
        }
    }

    bool hasStarted()
    {
        if (states.getCurrentStateName() == "playing") {
            return true;
        }
        return false;
    }

    public int getScore()
    {
        return score;
    }

    public void addScore(int amt)
    {
        score += amt;
    }

}