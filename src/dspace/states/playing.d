module dspace.states.playing;

import dsfml.graphics;
import star.entity;

import engine.game;
import engine.resourcemgr;
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
    private Entity       player;
    private AnimationSet playerAnimSet;
    private Velocity     playerVel;

    this(Game pGame)
    {
        game = pGame;
        window = game.getWindow();
        entityEngine = new Engine();
        entityEngine.systems.add(new MovementSystem(window));
        entityEngine.systems.add(new RenderSystem(window));
        entityEngine.systems.configure();

        background = ResourceManager.getSprite("images/background.png");
        background.textureRect = IntRect(0, cast(int)backgroundPosition, 400, 600);

        createPlayer();
    }

    void createPlayer()
    {
        player        = entityEngine.entities.create();
        playerAnimSet = ResourceManager.getAnimationSet("anim/player.animset");
        playerVel     = new Velocity(0.0f, 0.0f);

        player.add(new Bounds(55.0f, 61.0f, true));
        player.add(new Position(172.5f, 539.0f));
        player.add(new Renderable(playerAnimSet));
        player.add(playerVel);
    }

    bool enter(string prev)
    {
        return (prev == "startmenu" || prev == "gameover");
    }

    bool exit(string next)
    {
        return (next == "gameover");
    }

    void handleInput(Event evt) {}

    void update(float delta)
    {
        if (backgroundPosition > 0.0f) {
            backgroundPosition -= scrollSpeed * delta;
            backgroundPosition = (backgroundPosition > 0.0f) ? backgroundPosition : 0.0f;
            background.textureRect = IntRect(0, cast(int)backgroundPosition, 400, 600);
        }

        if (Keyboard.isKeyPressed(Keyboard.Key.Left)) {
            playerVel.velocity.x = -playerSpeed;
            playerAnimSet.setAnimation("bank-left");
        } else if (Keyboard.isKeyPressed(Keyboard.Key.Right)) {
            playerVel.velocity.x = playerSpeed;
            playerAnimSet.setAnimation("bank-right");
        } else {
            playerVel.velocity.x = 0.0f;
            playerAnimSet.setAnimation("idle");
        }

        entityEngine.systems.update!(MovementSystem)(delta);

        window.clear();
        window.draw(background);
        entityEngine.systems.update!(RenderSystem)(delta);
        window.display();
    }
}