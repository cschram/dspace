module engine.spawner;

import std.random;

import star.entity;
import dsfml.graphics;

import engine.resourcemgr;
import engine.components.bounds;
import engine.components.position;
import engine.components.renderable;
import engine.components.velocity;

struct EntityDetails
{
    Vector2f size;
    string   animation;
    Vector2f velocity;
}

class Spawner
{
    static immutable(float) minInterval = 0.1f;

    private   EntityDetails   details;
    private   FloatRect       area;
    private   float           timer = 0.0f;
    protected Engine          engine;
    protected float           interval;

    this(Engine pEngine, FloatRect pArea, float pInterval, EntityDetails pDetails)
    {
        engine   = pEngine;
        area     = pArea;
        interval = pInterval;
        details  = pDetails;

        area.width  -= details.size.x;
        area.height -= details.size.y;
    }

    private Vector2f getRandomPos()
    {
        float left, top;
        if (area.width <= 0.0f) {
            left = area.left;
        } else {
            left = uniform(area.left, area.left + area.width);
        }
        if (area.height <= 0.0f) {
            top = area.top;
        } else {
            top = uniform(area.top, area.top + area.height);
        }
        return Vector2f(left, top);
    }

    protected void configureEntity(Entity entity, Vector2f pos)
    {
        entity.add(new Bounds(details.size));
        entity.add(new Position(pos));
        entity.add(new Renderable(ResourceManager.getAnimation(details.animation)));
        entity.add(new Velocity(details.velocity));
    }

    float getInterval()
    {
        return interval;
    }

    void setInterval(float pInterval)
    {
        if (pInterval < minInterval) {
            interval = minInterval;
        } else {
            interval = pInterval;
        }
    }

    Entity spawn()
    {
        auto entity = engine.entities.create();
        configureEntity(entity, getRandomPos());
        return entity;
    }

    final Entity update(float delta)
    {
        timer += delta;
        if (timer >= interval) {
            timer = 0.0f;
            return spawn();
        }
        return null;
    }
}