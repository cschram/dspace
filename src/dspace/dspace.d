module dspace.dspace;

import dsfml.graphics;

import engine.game;
import dspace.states.gameover;
import dspace.states.playing;
import dspace.states.startmenu;

class DSpace : Game
{
    override void configure()
    {
        cfgVideoMode   = VideoMode(400, 600);
        cfgWindowTitle = "DSpace";
    }

    override void setupStates()
    {
        stateMgr.addState("startmenu", new StartMenuState(this));
        stateMgr.addState("playing",   new PlayingState(this));
        stateMgr.addState("gameover",  new GameOverState(this));
    }
}