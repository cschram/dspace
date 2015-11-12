module dspace.dspace;

import dsfml.graphics;

import engine.configmgr;
import engine.game;
import dspace.assemblies.bullet;
import dspace.assemblies.drone;
import dspace.assemblies.explosion;
import dspace.assemblies.player;
import dspace.assemblies.seraph;
import dspace.states.gameover;
import dspace.states.playing;
import dspace.states.startmenu;

class DSpace : Game
{
    this()
    {
        super();
        world = new World(getWindow(), [
            "bullet": &bulletAssembly,
            "drone": &droneAssembly,
            "explosion": &explosionAssembly,
            "player": &playerAssembly,
            "seraph": &seraphAssembly
        ]);

        world.background = ResourceManager.getSprite("images/background.png");
        background.textureRect = IntRect(0, 1000, 400, 600);
    }

    World getWorld() { return world; }

protected:
    override void configure()
    {
        auto config = ConfigManager.get();
        config.videoMode = VideoMode(400, 600);
        config.windowTitle = "DSpace";
    }

    override void setupStates()
    {
        stateMgr.addState("startmenu", new StartMenuState(this));
        stateMgr.addState("playing",   new PlayingState(this));
        stateMgr.addState("gameover",  new GameOverState(this));
    }

private:
    World world;
}