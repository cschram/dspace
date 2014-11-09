module dspace.systems.animation;

import std.stdio;
import artemisd.all;

import dspace.core.game;
import dspace.components.renderer;

class AnimationSystem : EntityProcessingSystem
{
    mixin TypeDecl;

    World world;

    this(Game game)
    {
        writeln("AnimationSystem initialized.");
        world = game.getWorld();
        super(Aspect.getAspectForAll!(Renderer));
    }

    override void process(Entity e)
    {
        auto renderer = e.getComponent!Renderer;
        renderer.target.tick(world.getDelta());
        //if (!renderer.target.tick(world.getDelta())) {
        //    renderer.visible = false;
        //}
    }
}