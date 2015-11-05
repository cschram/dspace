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
    A    = 0,
    B    = 1,
    BOTH = 2
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

    this(Physics target)
    {
        size           = target.size;
        offset         = target.offset;
        velocity       = target.velocity;
        collisionMode  = target.collisionMode;
        collisionGroup = target.collisionGroup;
        collideWith    = target.collideWith;
        keepInWindow   = target.keepInWindow;
    }

    FloatRect getBounds(Vector2f position)
    {
        return FloatRect(position + offset, size);
    }
}