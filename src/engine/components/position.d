module engine.components.position;

import dsfml.system;

class Position
{
    Vector2f position;
    Vector2f lastPosition;

    this(Vector2f pPosition)
    {
        position = pPosition;
    }

    this(float x, float y)
    {
        position = Vector2f(x, y);
    }
}