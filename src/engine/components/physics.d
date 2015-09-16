module engine.components.physics;

import dsfml.graphics;
import star.entity;

class Physics
{
    Vector2f  size;
    Vector2f  offset;
    Vector2f  velocity;
    bool      keepInWindow;

    this(Vector2f pSize, Vector2f pOffset=Vector2f(0,0), Vector2f pVelocity=Vector2f(0,0), bool pKeepInWindow=false)
    {
        size         = pSize;
        velocity     = pVelocity;
        offset       = pOffset;
        keepInWindow = pKeepInWindow;
    }

    FloatRect getBounds(Vector2f position)
    {
        return FloatRect(position + offset, position + offset + size);
    }
}