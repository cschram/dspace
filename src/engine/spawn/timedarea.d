module engine.spawn.timedarea;

import dsfml.graphics;
import star.entity;

import engine.spawn.area;
import engine.spawn.spawner;

class TimedAreaSpawner : SpawnArea
{
    static immutable(float) minInterval = 0.05;

    protected float         startInterval;
    protected float         interval;
    protected EntityDetails details;
    private   float         timer = 0;

    this(EntityManager entities, FloatRect spawnArea, float pInterval, EntityDetails pDetails)
    {
        super(entities, spawnArea);
        startInterval = pInterval;
        interval      = pInterval;
        details       = pDetails;
    }

    final float getInterval()
    {
        return interval;
    }

    final void setInterval(float pInterval)
    {
        if (pInterval < minInterval) {
            interval = minInterval;
        } else {
            interval = pInterval;
        }
    }

    final void resetInterval()
    {
        interval = startInterval;
    }

    final void update(float delta)
    {
        timer += delta;
        if (timer >= interval) {
            spawn(details);
            timer = 0;
        }
    }
}