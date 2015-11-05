module dspace.controllers.spawnzone;

import std.algorithm;
import std.array;
import std.random;

import dsfml.graphics;
import star.entity;

import engine.controller;
import engine.spawner;
import engine.util;
import engine.world;

struct SpawnOption
{
    string name;
    float  rate;
    VarMap options;
}

class SpawnZone : Controller
{
    this(FloatRect _area, float _interval, SpawnOption[] _options)
    {
        area       = _area;
        interval   = _interval;
        options    = _options;
        timer      = 0;
        spawnRates = map!(option => option.rate)(_options).array;
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

private:
    FloatRect     area;
    float         interval;
    SpawnOption[] options;
    float[]       spawnRates;
    float         timer;
}