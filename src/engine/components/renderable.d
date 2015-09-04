module engine.components.renderable;

import dsfml.graphics;

class Renderable
{
    Drawable target;

    this(Drawable pTarget)
    {
        target = pTarget;
    }
}