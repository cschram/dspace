module dspace.spawners.enemy;

import dsfml.graphics;
import star.entity;

import engine.resourcemgr;
import engine.components.controller;
import engine.components.physics;
import engine.components.renderable;
import engine.spawn.spawner;
import engine.spawn.timedarea;
import dspace.controllers.enemy;

enum EnemyType
{
    DRONE  = 0,
    SERAPH = 1
}

class EnemySpawner : TimedAreaSpawner
{
    private EnemyType type;

    this(EntityManager entities, EnemyType pType, FloatRect pSpawnArea)
    {
        type = pType;
        float interval;
        EntityDetails details;
        if (type == EnemyType.DRONE) {
            interval = 4;
            details = EntityDetails(Vector2f(0, 0), Vector2f(0, 150));
        } else if (type == EnemyType.SERAPH) {
            interval = 8;
            details = EntityDetails(Vector2f(0, 0), Vector2f(0, 100));
        }
        pSpawnArea.width -= 17;
        super(entities, pSpawnArea, interval, details);
    }

    override void configureEntity(Entity entity, EntityDetails details)
    {
        super.configureEntity(entity, details);

        auto physics = entity.component!Physics();
        physics.size = Vector2f(17, 20);

        if (type == EnemyType.DRONE) {
            entity.add(new EntityController(new EnemyController(1)));
            entity.add(new Renderable(ResourceManager.getSprite("images/drone.png")));
        } else if (type == EnemyType.SERAPH) {
            entity.add(new EntityController(new EnemyController(2)));
            entity.add(new Renderable(ResourceManager.getSprite("images/seraph.png")));
        }
    }
}