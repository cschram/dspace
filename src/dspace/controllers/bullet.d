module dspace.controllers.bullet;

import dsfml.graphics;
import star.entity;

import engine.controller;
import engine.world;
import engine.components.position;

class BulletController : Controller
{
    bool hasHit = false;

    void collide(Entity entity, Entity target)
    {
        hasHit = true;
    }

    void update(Entity entity, World world)
    {
        if (hasHit) {
            entity.destroy();
            return;
        }

        auto position = entity.component!Position().position;
        if (position.y < -8) {
            entity.destroy();
        }
    }
}