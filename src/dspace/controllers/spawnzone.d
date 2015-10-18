module dspace.controllers.spawnzone;

import dsfml.graphics;
import star.entity;

import engine.controller;
import engine.spawner;
import engine.util;
import engine.world;

class SpawnZone : Controller
{
    private string    name;
    private FloatRect bounds;
    private float     startInterval;
    private float     interval;
    private float     timer = 0;
    private World     world;

    this(string _name, FloatRect _bounds, float _interval, World _world)
    {
        name          = _name;
        bounds        = _bounds;
        startInterval = _interval;
        interval      = _interval;
        world         = _world;
    }

    void collide(Entity entity, Entity target) { }

    void update(Entity entity, Game game, float delta)
    {
        timer += delta;
        if (timer >= interval) {
            world.spawn(name, EnemyDetails(getRandomPos(bounds)));
            timer = 0;
        }
    }
}