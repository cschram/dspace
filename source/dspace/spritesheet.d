module dspace.spritesheet;

import dsfml.graphics;

class SpriteSheet {
private:

    Sprite   sheet;
    Vector2i size;
    int      count;
    int      index;

public:

    this(Sprite sheet, Vector2i size, int index=0) {
        this.sheet = sheet;
        this.size  = size;
        this.count = sheet.getTexture().getSize().x / size.x;
        setIndex(index);
    }

    void setIndex(int i) {
        if (i < count) {
            index = i;
            sheet.textureRect = IntRect(i * size.x, 0, size.x, size.y);
        } else {
            setIndex(0);
        }
    }
}