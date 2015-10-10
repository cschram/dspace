module dspace.controllers.animation;

import star.entity;

import engine.controller;
import engine.game;
import engine.resourcemgr;
import engine.components.renderable;

class AnimationController : Controller
{
    void collide(Entity entity, Entity target) { }
    void update(Entity entity, Game game, float delta)
    {
        auto renderable = entity.component!Renderable();
        if (!renderable.anim.isPlaying()) {
            entity.destroy();
        }
    }
}