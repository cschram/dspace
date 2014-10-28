module dspace.states.game.gameover;

import dsfml.graphics;
import dspace.game;
import dspace.states.gamestate;

class GameOverState : GameState
{
    private static const(string) name = "gameover";

    private Sprite gameover;

    this()
    {
        auto resourceMgr = Game.getInstance().getResourceMgr();
        gameover = resourceMgr.getSprite("images/gameover.png");
        gameover.color = Color(255, 255, 255, 200);
    }

    override const(string) getName() const
    {
        return name;
    }

    override void render(RenderWindow window)
    {
        window.draw(gameover);
    }
}