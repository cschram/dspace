module dspace.systems.render;

import dsfml.graphics;
import artemisd.all;

import dspace.game;
import dspace.components.dimensions;
import dspace.components.entitysprite;

class RenderSystem : EntityProcessingSystem {
    mixin TypeDecl;

    this() {
        super(Aspect.getAspectForAll!(Dimensions, EntitySprite));
    }

    override void process(Entity e) {
        auto window = Game.getInstance().getWindow();
        auto sprite = e.getComponent!EntitySprite;
        auto dim    = e.getComponent!Dimensions;
        if (sprite.prepareRender(dim.position)) {
            window.draw(sprite.getSprite());
        }
    }
}