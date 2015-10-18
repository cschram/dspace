module dspace.spawners.enemy;

import dsfml.graphics;
import star.entity;

import engine.resourcemgr;
import engine.components.controller;
import engine.components.physics;
import engine.components.renderable;
import engine.spawn.spawner;
import dspace.controllers.enemy;
import dspace.spawners.explosion;

class DroneSpawner : Spawner
{
    private ExplosionSpawner explosionSpawn;

    this()
    {
        explosionSpawn = new ExplosionSpawner(entities);
    }

    override void configureEntity(Entity entity, EntityDetails details)
    {
        super.configureEntity(entity, details);

        auto physics = entity.component!Physics();
        physics.size = Vector2f(17, 20);
        physics.velocity = Vector2f(0, 150);

        entity.add(new EntityController(new EnemyController(1, explosionSpawn)));
        entity.add(new Renderable(ResourceManager.getSprite("images/drone.png")));
    }
}