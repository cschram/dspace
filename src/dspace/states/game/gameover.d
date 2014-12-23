module dspace.states.game.gameover;

import artemisd.all;
import dsfml.graphics;

import dspace.core.game;
import dspace.core.statemachine;
import dspace.states.gamestate;

class GameOverState : GameState
{
    private static const(string) name = "gameover";

    private Entity player;
    private Sprite gameover;

    this(Game pGame)
    {
        super(pGame);
        player = game.getPlayer();
        auto resourceMgr = Game.getResourceMgr();
        gameover = resourceMgr.getSprite("images/gameover.png");
        gameover.color = Color(255, 255, 255, 155);
    }

    override const(string) getName() const
    {
        return name;
    }

    override bool onEnter(State previousState)
    {
        player.disable();
        return super.onEnter(previousState);
    }

    override bool onExit(State nextState)
    {
        game.clearEntities();
        return super.onExit(nextState);
    }

    override protected void keyPressed(Keyboard.Key code)
    {
        switch (code) {
            case Keyboard.Key.Space:
                parent.transitionTo("playing");
                break;

            default:
                break;
        }
    }

    override protected void renderUI(RenderWindow window)
    {
        window.draw(gameover);
    }
}