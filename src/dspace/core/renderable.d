module dspace.core.renderable;

import dsfml.graphics;

interface Renderable
{
    Sprite getSprite();
    bool   tick(float delta);
}