module engine.components.physics;

import dsfml.graphics;
import star.entity;

enum CollisionMode
{
    NONE    = 0,
    LITE    = 1,
    PASSIVE = 2,
    ACTIVE  = 3,
    FIXED   = 4
}

enum CollisionGroup
{
    NONE = 0,
    A    = 1,
    B    = 2,
    BOTH = 3
}

struct Collision
{
    Entity a;
    Entity b;
}

class Physics
{
    Vector2f       size;
    Vector2f       offset;
    Vector2f       velocity;
    CollisionMode  collisionMode;
    CollisionGroup collisionGroup;
    CollisionGroup collideWith;
    bool           keepInWindow;

    invariant
    {
        assert(collisionGroup != CollisionGroup.BOTH);
    }

    this(Vector2f       pSize,
         Vector2f       pOffset=Vector2f(0,0),
         Vector2f       pVelocity=Vector2f(0,0),
         CollisionMode  pCollisionMode=CollisionMode.PASSIVE,
         CollisionGroup pCollisionGroup=CollisionGroup.A,
         CollisionGroup pCollideWith=CollisionGroup.BOTH,
         bool           pKeepInWindow=false)
    {
        size           = pSize;
        velocity       = pVelocity;
        offset         = pOffset;
        collisionMode  = pCollisionMode;
        collisionGroup = pCollisionGroup;
        collideWith    = pCollideWith;
        keepInWindow   = pKeepInWindow;
    }

    FloatRect getBounds(Vector2f position)
    {
        return FloatRect(position + offset, size);
    }
}