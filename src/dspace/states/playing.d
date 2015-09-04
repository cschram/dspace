module dspace.states.playing;

import dsfml.graphics;
import star.entity;

import engine.game;
import engine.resourcemgr;
import engine.components.bounds;
import engine.components.position;
import engine.components.renderable;
import engine.components.velocity;
import engine.states.state;
import engine.systems.render;

class PlayingState : State
{
    private static float scrollSpeed = 30.0f;

    private Game         game;
    private RenderWindow window;
    private Engine       entityEngine;
    private Sprite       background;
    private float        backgroundPosition = 1000.0f;

    this(Game pGame)
    {
        game = pGame;
        window = game.getWindow();
        entityEngine = new Engine();
        entityEngine.systems.add(new RenderSystem(window));
        entityEngine.systems.configure();

        background = ResourceManager.getSprite("images/background.png");
        background.textureRect = IntRect(0, cast(int)backgroundPosition, 400, 600);

        createPlayer();
    }

    void createPlayer()
    {
        auto player = entityEngine.entities.create();
        player.add(new Bounds(55.0f, 61.0f));
        player.add(new Position(172.5f, 539.0f));
        player.add(new Renderable(ResourceManager.getAnimationSet("anim/player.animset")));
        player.add(new Velocity(0.0f, 0.0f));
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

        window.clear();
        window.draw(background);
        entityEngine.systems.update!(RenderSystem)(delta);
        window.display();
    }
}