module dspace.states.game.startmenu;

import std.stdio;
import dsfml.graphics;
import dspace.game;
import dspace.states.gamestate;

class StartMenuState : GameState
{
    private static const(string) name = "startmenu";

    private Text startText;

    this()
    {
        auto resourceMgr = Game.getInstance().getResourceMgr();
        auto font = resourceMgr.getFont("fonts/slkscr.ttf");
        startText = new Text("Press Space to Start", font, 30);
        startText.position = Vector2f(8, 270);
    }

    override const(string) getName() const
    {
        return name;
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

    override void render(RenderWindow window)
    {
        window.draw(startText);
    }
}