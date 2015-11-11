module dspace.controllers.animation;

import star.entity;

import engine.controller;
import engine.world;
import engine.components.renderable;

class AnimationController : Controller
{
    void collide(Entity entity, Entity target) { }
    void update(Entity entity, World world)
    {
        auto renderable = entity.component!Renderable();
        if (!renderable.anim.isPlaying()) {
            entity.destroy();
        }
    }
}