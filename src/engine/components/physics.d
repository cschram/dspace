module engine.components.physics;

import dsfml.graphics;
import star.entity;

enum CollisionMode
{
    NONE,
    LITE,
    PASSIVE,
    ACTIVE,
    FIXED
}

enum CollisionGroup
{
    A,
    B,
    BOTH
}

// NOTE: This should probably be split up into two or more components.
class Physics
{
    Vector2f       size;
    Vector2f       offset;
    Vector2f       velocity;
    CollisionMode  collisionMode;
    CollisionGroup collisionGroup;
    CollisionGroup collideWith;
    bool           keepInWindow; //  NOTE: This should definitely go in favor of a Controller-based approach.

    invariant
    {
        assert(collisionGroup != CollisionGroup.BOTH);
    }

    this(Vector2f _size,
         Vector2f _offset=Vector2f(0,0),
         Vector2f _velocity=Vector2f(0,0),
         CollisionMode _collisionMode=CollisionMode.PASSIVE,
         CollisionGroup _collisionGroup=CollisionGroup.A,
         CollisionGroup _collideWith=CollisionGroup.BOTH,
         bool _keepInWindow=false)
    {
        size = _size;
        velocity = _velocity;
        offset = _offset;
        collisionMode = _collisionMode;
        collisionGroup = _collisionGroup;
        collideWith = _collideWith;
        keepInWindow = _keepInWindow;
    }

    this(Physics target)
    {
        size = target.size;
        offset = target.offset;
        velocity = target.velocity;
        collisionMode = target.collisionMode;
        collisionGroup = target.collisionGroup;
        collideWith = target.collideWith;
        keepInWindow = target.keepInWindow;
    }

    FloatRect getBounds(Vector2f position)
    {
        return FloatRect(position + offset, size);
    }
}