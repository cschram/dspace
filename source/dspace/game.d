module dspace.game;

import std.stdio;
import std.conv;
import std.string;
import core.memory;

import dsfml.graphics;
import dsfml.audio;

import artemisd.all;

import dspace.resources;
import dspace.components.dimensions;
import dspace.components.entitysprite;
import dspace.components.entitystate;
import dspace.components.spritesheet;
import dspace.components.velocity;
import dspace.systems.movement;
import dspace.systems.render;

class Game {

    //
    // Constants
    //

    public static immutable(VideoMode) screenMode  = VideoMode(400, 600);
    public static immutable(float)     scrollSpeed = 0.5;
    public static immutable(float)     playerSpeed = 250;

    //
    // Private Variables
    //

    private static Game _instance;

    // State
    private RenderWindow    window;
    private ResourceManager resources;
    private World           world;
    private bool            started;
    private bool            moving;
    private Entity          player;
    private int             score;

    //
    // Private Methods
    //

    private this() {
        resources = new ResourceManager();
    }

    //
    // Public Methods
    //

    public static Game getInstance() {
        if (_instance is null) {
            _instance = new Game();
        }
        return _instance;
    }

    public RenderWindow getWindow() {
        return window;
    }

    public ResourceManager getResources() {
        return resources;
    }

    public World getWorld() {
        return world;
    }

    public Entity getPlayer() {
        return player;
    }

    public void run() {
        writeln("Loading...");

        started = false;
        moving  = false;
        score   = 0;

        float backgroundPosition = 1800;

        // Setup window
        window = new RenderWindow(screenMode, "DSpace");
        window.setFramerateLimit(60);

        // Setup world
        world = new World();
        world.setSystem(new MovementSystem);
        world.setSystem(new RenderSystem);
        auto groupManager = new GroupManager;
        auto tagManager   = new TagManager;
        world.setManager(groupManager);
        world.setManager(tagManager);
        world.initialize();

        // Setup player
        player                 = world.createEntity();
        auto playerDim         = new Dimensions(Vector2f(172.5, 539), Vector2f(55, 61));
        auto playerVel         = new Velocity(true);
        auto playerState       = new EntityState(10);
        auto playerSprite      = resources.getSprite("content/images/ship.png");
        auto playerSpriteSheet = new SpriteSheet(playerSprite, Vector2i(55, 61), 3);
        player.addComponent(playerDim);
        player.addComponent(playerVel);
        player.addComponent(playerState);
        player.addComponent(playerSpriteSheet);
        player.addToWorld();

        // Images
        auto background        = resources.getSprite("content/images/background.png");
        auto healthbar         = resources.getSprite("content/images/healthbar.png");
        auto gameover          = resources.getSprite("content/images/gameover.png");
        background.textureRect = IntRect(0, cast(int)backgroundPosition, 400, 600);
        gameover.color         = Color(255, 255, 255, 200);

        // Text
        auto font          = resources.getFont("content/fonts/slkscr.ttf");
        auto startText     = new Text("Press Space to Start", font, 30);
        auto scoreText     = new Text("Score: 0", font, 13);
        startText.position = Vector2f(8, 270);
        scoreText.position = Vector2f(2, 10);

        GC.collect();

        // Main loop
        writeln("Running...");
        while (window.isOpen()) {
            // Poll events
            Event e;
            while (window.pollEvent(e)) {
                switch (e.type) {
                    default:
                        break;

                    // Close button event
                    case e.EventType.Closed:
                        window.close();
                        break;

                    // Keyboard input
                    case e.EventType.KeyPressed:
                        switch (e.key.code) {
                            default:
                                break;

                            case Keyboard.Key.Space:
                                if (!started) {
                                    started = true;
                                    moving  = true;
                                }
                                break;
                        }
                        break;
                }
            }

            // Game logic
            if (started) {
                if (moving) {
                    backgroundPosition -= scrollSpeed;
                    // Avoiding creating a new IntRect every loop iteration
                    auto updatedRect = background.textureRect;
                    updatedRect.top = cast(int)backgroundPosition;
                    background.textureRect = updatedRect;
                    moving = (backgroundPosition > 0);
                }

                // Player movement
                if (Keyboard.isKeyPressed(Keyboard.Key.Left)) {
                    playerVel.vel.x = -playerSpeed;
                } else if (Keyboard.isKeyPressed(Keyboard.Key.Right)) {
                    playerVel.vel.x = playerSpeed;
                } else {
                    playerVel.vel.x = 0;
                }
            }

            // Render
            window.clear();
            window.draw(background);

            if (started) {
                world.setDelta(1/60.0f);
                world.process();

                // UI
                if (playerState.health > 0) {
                    healthbar.textureRect = IntRect(0, 0, 8 * playerState.health, 8);
                    window.draw(healthbar);
                } else {
                    window.draw(gameover);
                }
                scoreText.setString(to!dstring(format("Score: %s", score)));
                window.draw(scoreText);
            } else {
                window.draw(startText);
            }

            window.display();
        }
    }

    public bool hasStarted() {
        return started;
    }

    public void addScore(int amt) {
        score += amt;
    }

}