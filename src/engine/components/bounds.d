module engine.components.bounds;

import dsfml.graphics;

class Bounds
{
    FloatRect bounds;
    bool      keepInWindow;

    this(Vector2f size, bool keepInWin=false)
    {
        bounds       = FloatRect(0, 0, size.x, size.y);
        keepInWindow = keepInWin;
    }

    this(float width, float height, bool keepInWin=false)
    {
        bounds       = FloatRect(0, 0, width, height);
        keepInWindow = keepInWin;
    }
}