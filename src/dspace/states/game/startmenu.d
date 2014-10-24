module dspace.states.game.startmenu;

import std.stdio;
import dsfml.graphics;
import dspace.game;
import dspace.statemachine;
import dspace.states.gamestate;

class StartMenuState : GameState
{
    private static const(string)   name        = "startmenu";
    private static const(string)[] transitions = [ "playing" ];

    private Sprite background;
    private Text   startText;

    this()
    {
        auto resources = Game.getInstance().getResources();
        background = resources.getSprite("images/background.png");
        auto font = resources.getFont("fonts/slkscr.ttf");
        startText = new Text("Press Space to Start", font, 30);
        startText.position = Vector2f(8, 270);
    }

    override const(string) getName()
    {
        return name;
    }

    override const(string)[] getTransitions()
    {
        return transitions;
    }

    override bool onEnter(State previousState)
    {
        writeln("Entered StartMenuState");
        return true;
    }

    override void keyPressed(Keyboard.Key code)
    {
        switch (code) {
            case Keyboard.Key.Space:
                parent.transitionTo("playing");
                break;

            default:
                break;
        }
    }

    override void render()
    {
        auto game = Game.getInstance();
        auto window = game.getWindow();
        window.clear();
        window.draw(background);
        window.draw(startText);
        window.display();
    }
}