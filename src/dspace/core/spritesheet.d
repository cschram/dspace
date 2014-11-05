module dspace.core.spritesheet;

import dsfml.graphics;

import dspace.core.renderable;

class SpriteSheet : Renderable
{

    private Sprite   sheet;
    private Vector2i size;
    private int      count;
    private int      index;

    this(Sprite sheet, Vector2i size, int index=0)
    {
        this.sheet = sheet;
        this.size  = size;
        this.count = sheet.getTexture().getSize().x / size.x;
        setIndex(index);
    }

    void setIndex(int i)
    {
        if (i < count) {
            index = i;
            sheet.textureRect = IntRect(i * size.x, 0, size.x, size.y);
        } else {
            setIndex(0);
        }
    }

    Sprite getSprite()
    {
        return sheet;
    }

    bool tick(float delta)
    {
        return true;
    }
}