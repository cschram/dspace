module dspace.game;

import std.stdio;

import dsfml.graphics;
import dsfml.audio;

import artemisd.all;

import dspace.resources;
import dspace.components.dimensions;
import dspace.components.entitysprite;
import dspace.components.velocity;
import dspace.systems.movement;
import dspace.systems.render;

class Game {
public:
    // Constants
    static float     scrollSpeed = 0.5;
    static VideoMode screenMode  = VideoMode(400, 600);
    static float     playerSpeed = 250;

private:

    static Game _instance;

    // State
    RenderWindow    window;
    ResourceManager resources;
    World           world;
    bool            started;
    bool            moving;
    Entity          player;

    this() {
        resources = new ResourceManager();
    }

public:

    static Game getInstance() {
        if (_instance is null) {
            _instance = new Game();
        }
        return _instance;
    }

    RenderWindow getWindow() {
        return window;
    }

    ResourceManager getResources() {
        return resources;
    }

    World getWorld() {
        return world;
    }

    Entity getPlayer() {
        return player;
    }

    void run() {
        writeln("Loading...");

        started = false;
        moving  = false;

        // Setup window
        window  = new RenderWindow(screenMode, "DSpace");
        window.setFramerateLimit(60);

        // Setup world
        world = new World();
        world.setSystem(new MovementSystem);
        world.setSystem(new RenderSystem);
        world.initialize();

        // Setup player
        player            = world.createEntity();
        auto playerDim    = new Dimensions(Vector2f(172.5, 539), Vector2f(55, 61));
        auto playerVel    = new Velocity(true);
        auto playerSprite = resources.getSprite("content/images/ship-idle.png");
        player.addComponent(playerDim);
        player.addComponent(playerVel);
        player.addComponent(new EntitySprite(playerSprite));
        player.addToWorld();

        float backgroundPosition = 1800;

        // Images
        auto background = resources.getSprite("content/images/background.png");
        auto healthbar  = resources.getSprite("content/images/healthbar.png");
        auto gameover   = resources.getSprite("content/images/gameover.png");
        background.textureRect = IntRect(0, cast(int)backgroundPosition, 400, 600);

        // Text
        auto font = resources.getFont("content/fonts/slkscr.ttf");
        auto startText = new Text("Press Space to Start", font, 30);
        startText.position = Vector2f(8, 270);

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
                    backgroundPosition -=  scrollSpeed;
                    background.textureRect = IntRect(0, cast(int)backgroundPosition, 400, 600);
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
            } else {
                window.draw(startText);
            }

            window.display();
        }
    }

    bool hasStarted() {
        return started;
    }

}