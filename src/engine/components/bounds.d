module engine.components.bounds;

import dsfml.graphics;

class Bounds
{
    FloatRect bounds;

    this(Vector2f size)
    {
        bounds = FloatRect(0.0f, 0.0f, size.x, size.y);
    }

    this(float width, float height)
    {
        bounds = FloatRect(0.0f, 0.0f, width, height);
    }
}