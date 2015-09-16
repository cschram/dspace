module dspace.controllers.bullet;

import dsfml.graphics;
import star.entity;

import engine.game;
import engine.controller;
import engine.components.position;

class BulletController : Controller
{
    void update(Game game, Entity entity, float delta)
    {
        auto position = entity.component!Position().position;
        if (position.y < -8) {
            entity.destroy();
        }
    }
}