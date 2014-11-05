module dspace.states.game.gameover;

import dsfml.graphics;
import dspace.core.game;
import dspace.states.gamestate;

class GameOverState : GameState
{
    private static const(string) name = "gameover";

    private Sprite gameover;

    this(Game pGame)
    {
        super(pGame);
        auto resourceMgr = Game.getResourceMgr();
        gameover = resourceMgr.getSprite("images/gameover.png");
        gameover.color = Color(255, 255, 255, 200);
    }

    override const(string) getName() const
    {
        return name;
    }

    override protected void renderUI(RenderWindow window)
    {
        window.draw(gameover);
    }
}