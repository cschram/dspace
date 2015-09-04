module dspace.dspace;

import dsfml.graphics;

import engine.game;
import dspace.states.game;
import dspace.states.gameover;
import dspace.states.start;

class DSpace : Game
{
    override protected void initWindow()
    {
        window = new RenderWindow(VideoMode(400, 600), "DSpace");
        window.setFramerateLimit(60);
    }

    override void configure()
    {
        stateMgr.addState("start", new StartState(this));
        stateMgr.addState("game", new GameState(this));
        stateMgr.addState("gameover", new GameOverState(this));
    }
}