module dspace.components.spritesheet;

import dsfml.graphics;

import dspace.components.entitysprite;

class SpriteSheet : EntitySprite {
    Vector2i spriteSize;
    int      spriteCount;
    int      currentSprite;

    this(Sprite sprite, Vector2i size, int index=0) {
        super(sprite);
        spriteSize = size;
        spriteCount = sprite.getTexture().getSize.x / size.x;
        setIndex(index);
    }

    void setIndex(int index) {
        if (index < spriteCount) {
            currentSprite = index;
            sprite.textureRect = IntRect(index * spriteSize.x, 0, spriteSize.x, spriteSize.y);
        } else {
            setIndex(0);
        }
    }
}