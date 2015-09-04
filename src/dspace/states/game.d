module dspace.states.game;

import dsfml.graphics;

import engine.game;
import engine.resourcemgr;
import engine.states.state;

class GameState : State
{
    private static float scrollSpeed = 30.0f;

    private Game         game;
    private RenderWindow window;
    private Sprite       background;
    private float        backgroundPosition = 1000.0f;

    this(Game pGame)
    {
        game = pGame;
        window = game.getWindow();

        background = ResourceManager.getSprite("images/background.png");
        background.textureRect = IntRect(0, cast(int)backgroundPosition, 400, 600);
    }

    bool enter(string prev)
    {
        return (prev == "start" || prev == "gameover");
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
        window.display();
    }
}