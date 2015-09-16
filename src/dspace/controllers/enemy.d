module dspace.controllers.enemy;

import dsfml.graphics;
import star.entity;

import engine.game;
import engine.controller;
import engine.components.position;

class EnemyController : Controller
{
    void update(Game game, Entity entity, float delta)
    {
        auto position = entity.component!Position().position;
        if (position.y > game.getWindow().getSize().y) {
            entity.destroy();
        }
    }
}