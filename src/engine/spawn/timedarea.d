module engine.spawn.timedarea;

import dsfml.graphics;
import star.entity;

import engine.spawn.area;
import engine.spawn.spawner;

class TimedAreaSpawner : SpawnArea
{
    static immutable(float) minInterval = 0.05;

    protected float         interval;
    protected EntityDetails details;
    private   float         timer = 0;

    this(FloatRect pSpawnArea, float pInterval, EntityDetails pDetails)
    {
        super(pSpawnArea);
        interval = pInterval;
        details  = pDetails;
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

    final void update(EntityManager entities, float delta)
    {
        timer += delta;
        if (timer >= interval) {
            spawn(entities, details);
            timer = 0;
        }
    }
}