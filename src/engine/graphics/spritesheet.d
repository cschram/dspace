module engine.graphics.spritesheet;

import dsfml.graphics;

class SpriteSheet
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
}