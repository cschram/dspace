module dspace.components.dimensions;

import artemisd.all;
import dsfml.system;

enum CollideType
{
    NO_COLLIDE = 0, // Don't collide with other objects
    BLOCK      = 1, // Block other objects
    DAMAGE     = 2  // Damage other objects on collision
}

class Dimensions : Component
{
    mixin TypeDecl;

    Vector2f    position;
    Vector2f    lastPosition;
    Vector2f    size;
    CollideType collisionType;
    float       collisionDamage;

    this(Vector2f pPos, Vector2f pSize, CollideType pCollision=CollideType.BLOCK, float pCollisionDamage=0.0f)
    {
        position = pPos;
        lastPosition = pPos;
        size = pSize;
        collisionType = pCollision;
        collisionDamage = pCollisionDamage;
    }
}