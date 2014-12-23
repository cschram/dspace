module dspace.systems.ai;

import artemisd.all;

import dspace.components.ai;
import dspace.core.game;

class AISystem : EntityProcessingSystem
{
    mixin TypeDecl;

    World world;

    this(Game game)
    {
        world = game.getWorld();
        super(Aspect.getAspectForAll!AI);
    }

    override void process(Entity e)
    {
        auto ai = e.getComponent!AI;
        if (!ai.behavior.update(world.getDelta())) {
            e.deleteFromWorld();
        }
    }
}