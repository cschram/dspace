module dspace.components.velocity;

import artemisd.all;
import dsfml.system;

class Velocity : Component
{
    mixin TypeDecl;

    Vector2f velocity;
    bool     keepInWindow;

    this(Vector2f pVel=Vector2f(0.0f, 0.0f), bool pKeepInWindow=false)
    {
        velocity = pVel;
        keepInWindow = pKeepInWindow;
    }
}