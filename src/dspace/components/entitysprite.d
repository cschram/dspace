module dspace.components.entitysprite;

import dsfml.graphics;
import artemisd.all;

class EntitySprite : Component
{
    mixin TypeDecl;

    protected Sprite sprite;

    this(Sprite sprite)
    {
        this.sprite = sprite;
    }

    Sprite getSprite()
    {
        return sprite;
    }

    bool prepareRender(Vector2f position)
    {
        sprite.position = position;
        return true;
    }
}