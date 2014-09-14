module dspace.components.entitysprite;

import dsfml.graphics;
import artemisd.all;

class EntitySprite : Component {
    mixin TypeDecl;

    Sprite sprite;

    this(Sprite sprite) {
        this.sprite = sprite;
    }

    bool prepareRender(Vector2f position) {
        sprite.position = position;
        return true;
    }
}