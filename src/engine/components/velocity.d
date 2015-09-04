module engine.components.velocity;

import dsfml.system;

class Velocity
{
    Vector2f velocity;

    this(Vector2f pVelocity)
    {
        velocity = pVelocity;
    }

    this(float dx, float dy)
    {
        velocity = Vector2f(dx, dy);
    }
}