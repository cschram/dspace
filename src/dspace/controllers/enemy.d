module dspace.controllers.enemy;

import dsfml.graphics;
import star.entity;

import engine.game;
import engine.controller;
import engine.components.physics;
import engine.components.position;
import engine.spawn.spawner;
import dspace.spawners.explosion;

class EnemyController : Controller
{
    private int health;
    private ExplosionSpawner explosionSpawn;

    this(int pHealth, ExplosionSpawner pExplosionSpawn)
    {
        health = pHealth;
        explosionSpawn = pExplosionSpawn;
    }

    void collide(Entity entity, Entity target)
    {
        health -= 1;
    }

    void update(Entity entity, Game game, float delta)
    {
        auto position = entity.component!Position().position;
        auto size     = entity.component!Physics().size;

        if (health <= 0) {
            explosionSpawn.spawn(EntityDetails(position + (size / 2) - Vector2f(32, 32)));
            entity.destroy();
            return;
        }

        if (position.y > game.getWindow().getSize().y) {
            entity.destroy();
        }
    }
}