module dspace.states.startmenu;

import dsfml.graphics;

import engine.game;
import engine.resourcemgr;
import engine.states.state;

class StartMenuState : State
{
    private Game         game;
    private RenderWindow window;
    private Sprite       background;
    private Text         startText;

    this(Game pGame)
    {
        game = pGame;
        window = game.getWindow();

        background = ResourceManager.getSprite("images/background.png");
        background.textureRect = IntRect(0, 1000, 400, 600);

        auto font = ResourceManager.getFont("fonts/slkscr.ttf");
        startText = new Text("Press Space to Start", font, 30);
        startText.position = Vector2f(8, 270);
    }

    bool enter(string prev)
    {
        return false;
    }

    bool exit(string next)
    {
        return (next == "playing");
    }

    void handleInput(Event evt)
    {
        if (evt.type == Event.EventType.KeyPressed &&
            evt.key.code == Keyboard.Key.Space)
        {
            game.setState("playing");
        }
    }

    void update(float delta)
    {
        window.clear();
        window.draw(background);
        window.draw(startText);
        window.display();
    }
}