module dspace.components.dimensions;

import artemisd.all;
import dsfml.system;

// XXX: Should have more collision scenarios
enum CollideType
{
    NO_COLLIDE = 0,
    COLLIDE    = 1
}

class Dimensions : Component
{
    mixin TypeDecl;

    Vector2f    position;
    Vector2f    size;
    CollideType collisionType;

    this(Vector2f pPos, Vector2f pSize, CollideType pCollision=CollideType.COLLIDE)
    {
        position = pPos;
        size = pSize;
        collisionType = pCollision;
    }
}