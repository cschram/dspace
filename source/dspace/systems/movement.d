module dspace.systems.movement;

import artemisd.all;

import dspace.game;
import dspace.components.dimensions;
import dspace.components.velocity;

class MovementSystem : EntityProcessingSystem {
    mixin TypeDecl;

    this() {
        super(Aspect.getAspectForAll!(Dimensions, Velocity));
    }

    override void process(Entity e) {
        auto dim = e.getComponent!Dimensions;
        auto vel = e.getComponent!Velocity;

        auto delta = Game.getInstance().getWorld().getDelta();

        dim.position += vel.vel * delta;

        if (vel.keepInBounds) {
            float xMax = Game.screenMode.width - dim.size.x;
            float yMax = Game.screenMode.height - dim.size.y;
            if (dim.position.x < 0) {
                dim.position.x = 0;
            } else if (dim.position.x > xMax) {
                dim.position.x = xMax;
            }
            if (dim.position.y < 0) {
                dim.position.y = 0;
            } else if (dim.position.y > yMax) {
                dim.position.y = yMax;
            }
        }
    }
}