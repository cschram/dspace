module dspace.states.gameover;

import dsfml.graphics;

import engine.game;
import engine.resourcemgr;
import engine.states.state;

class GameOverState : State
{
    private Game         game;
    private RenderWindow window;
    private Sprite       background;
    private Sprite       splash;

    this(Game pGame)
    {
        game = pGame;
        window = game.getWindow();

        background = ResourceManager.getSprite("images/background.png");
        background.textureRect = IntRect(0, 1000, 400, 600);
        splash = ResourceManager.getSprite("images/gameover.png");
    }

    bool enter(string prev)
    {
        return (prev == "game");
    }

    bool exit(string next)
    {
        return (next == "game");
    }

    void handleInput(Event evt)
    {
        if (evt.type == Event.EventType.KeyPressed) {
            game.setState("game");
        }
    }

    void update(float delta)
    {
        window.clear();
        window.draw(background);
        window.draw(splash);
        window.display();
    }
}