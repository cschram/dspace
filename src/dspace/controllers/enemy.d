module dspace.controllers.enemy;

import dsfml.graphics;
import star.entity;

import engine.game;
import engine.controller;
import engine.components.position;

class EnemyController : Controller
{
    private int health;

    this(int pHealth)
    {
        health = pHealth;
    }

    void collide(Entity entity, Entity target)
    {
        health -= 1;
    }

    void update(Entity entity, Game game, float delta)
    {
        if (health <= 0) {
            entity.destroy();
            return;
        }

        auto position = entity.component!Position().position;
        if (position.y > game.getWindow().getSize().y) {
            entity.destroy();
        }
    }
}