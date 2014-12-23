module dspace.systems.movement;

import artemisd.all;

import dspace.components.dimensions;
import dspace.components.velocity;
import dspace.core.game;

class MovementSystem : EntityProcessingSystem
{
    mixin TypeDecl;

    Game  game;
    float delta;

    this(Game pGame)
    {
        game = pGame;
        super(Aspect.getAspectForAll!(Dimensions, Velocity));
    }

    override void begin()
    {
        delta = game.getWorld().getDelta();
    }

    override void process(Entity e)
    {
        auto dim = e.getComponent!Dimensions;
        auto vel = e.getComponent!Velocity;

        dim.lastPosition = dim.position;
        dim.position += vel.velocity * delta;

        if (vel.keepInWindow) {
            if (dim.position.x < 0) {
                dim.position.x = 0;
            } else if ((dim.position.x + dim.size.x) > Game.screenMode.width) {
                dim.position.x = Game.screenMode.width - dim.size.x;
            }
            if (dim.position.y < 0) {
                dim.position.y = 0;
            } else if ((dim.position.y + dim.size.y) > Game.screenMode.height) {
                dim.position.y = Game.screenMode.height - dim.size.y;
            }
        } else {
            if (
                (dim.position.x + dim.size.x) < 0 ||
                dim.position.x > Game.screenMode.width ||
                (dim.position.y + dim.size.y) < 0 ||
                dim.position.y > Game.screenMode.height
            ) {
                e.deleteFromWorld();
            }
        }
    }
}