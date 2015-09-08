module dspace.states.playing;

debug import std.stdio;
import std.conv;
import std.string;

import dsfml.graphics;
import star.entity;

import engine.game;
import engine.resourcemgr;
import engine.spawner;
import engine.components.bounds;
import engine.components.position;
import engine.components.renderable;
import engine.components.velocity;
import engine.graphics.animationset;
import engine.states.state;
import engine.systems.movement;
import engine.systems.render;

class PlayingState : State
{
    private static immutable(float) scrollSpeed = 30.0f;
    private static immutable(float) playerSpeed = 250.0f;

    private Game         game;
    private RenderWindow window;
    private Engine       entityEngine;
    private Sprite       background;
    private float        backgroundPosition = 1000.0f;
    private Text         fpsText;
    private Entity       player;
    private AnimationSet playerAnimSet;
    private Velocity     playerVel;
    private Spawner[]    spawners;

    this(Game pGame)
    {
        game         = pGame;
        window       = game.getWindow();
        entityEngine = new Engine();
        entityEngine.systems.add(new MovementSystem(window));
        entityEngine.systems.add(new RenderSystem(window));
        entityEngine.systems.configure();

        background = ResourceManager.getSprite("images/background.png");
        background.textureRect = IntRect(0, cast(int)backgroundPosition, 400, 600);

        auto font = ResourceManager.getFont("fonts/slkscr.ttf");
        fpsText = new Text("FPS: 0", font, 20);

        createPlayer();
        createSpawners();
    }

    void createPlayer()
    {
        player        = entityEngine.entities.create();
        playerAnimSet = ResourceManager.getAnimationSet("anim/player.animset");
        playerVel     = new Velocity(0, 0);

        player.add(new Bounds(55, 61, true));
        player.add(new Position(172.5, 539));
        player.add(new Renderable(playerAnimSet));
        player.add(playerVel);
    }

    void createSpawners()
    {
        auto windowSize = window.getSize();
        auto spawnArea = FloatRect(0, 0, windowSize.x, 0);
        spawners ~= new Spawner(entityEngine, spawnArea, 4, EntityDetails(
            Vector2f(17, 20),
            "anim/drone.anim",
            Vector2f(0, 150)
        ));
        spawners ~= new Spawner(entityEngine, spawnArea, 8, EntityDetails(
            Vector2f(17, 20),
            "anim/seraph.anim",
            Vector2f(0, 100)
        ));
    }

    bool enter(string prev)
    {
        return (prev == "startmenu" || prev == "gameover");
    }

    bool exit(string next)
    {
        return (next == "gameover");
    }

    void handleInput(Event e) { }

    void update(float delta)
    {
        if (backgroundPosition > 0) {
            backgroundPosition -= scrollSpeed * delta;
            backgroundPosition = (backgroundPosition > 0) ? backgroundPosition : 0;
            background.textureRect = IntRect(0, cast(int)backgroundPosition, 400, 600);
        }

        if (Keyboard.isKeyPressed(Keyboard.Key.Left)) {
            playerVel.velocity.x = -playerSpeed;
            playerAnimSet.setAnimation("bank-left");
        } else if (Keyboard.isKeyPressed(Keyboard.Key.Right)) {
            playerVel.velocity.x = playerSpeed;
            playerAnimSet.setAnimation("bank-right");
        } else {
            playerVel.velocity.x = 0;
            playerAnimSet.setAnimation("idle");
        }

        foreach (spawner; spawners) {
            spawner.update(delta);
            auto interval = spawner.getInterval();
            if (interval > Spawner.minInterval) {
                spawner.setInterval(interval - (delta / 10));
            }
        }

        entityEngine.systems.update!(MovementSystem)(delta);

        auto fps = cast(uint)(1.0f / delta);
        fpsText.setString(to!dstring(format("FPS: %s", fps)));

        window.clear();
        window.draw(background);
        entityEngine.systems.update!(RenderSystem)(delta);
        window.draw(fpsText);
        window.display();
    }
}