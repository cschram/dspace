module dspace.states.game.gameover;

import dsfml.graphics;
import dspace.game;
import dspace.statemachine;
import dspace.states.gamestate;

class GameOverState : GameState
{
    private static const(string)   name        = "gameover";
    private static const(string)[] transitions = [ "playing" ];

    private Sprite background;
    private Sprite gameover;

    this()
    {
        auto resources = Game.getInstance().getResources();
        background = resources.getSprite("images/background.png");
        gameover = resources.getSprite("images/gameover.png");
        gameover.color = Color(255, 255, 255, 200);
    }

    override const(string) getName()
    {
        return name;
    }

    override const(string)[] getTransitions()
    {
        return transitions;
    }
}