module dspace.entity;

import std.stdio;

import dsfml.graphics;
import dspace.game;

class Entity
{
    protected Vector2f position;
    protected Vector2f size;
    protected Vector2f velocity;
    protected Sprite   sprite;

    this(Vector2f pos)
    {
        position = pos;
        sprite.position = pos;
    }

    Vector2f getPosition()
    {
        return position;
    }

    Vector2f getSize()
    {
        return size;
    }

    FloatRect getBounds()
    {
        return FloatRect(position, size);
    }

    Vector2f getVelocity()
    {
        return velocity;
    }

    Sprite getSprite()
    {
        return sprite;
    }

    bool isDrawable()
    {
        return true;
    }

    void update(float delta)
    {
        position += velocity * delta;
        sprite.position = position;
    }
}