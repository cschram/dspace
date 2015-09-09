module dspace.spawners.enemy;

import dsfml.graphics;
import star.entity;

import engine.resourcemgr;
import engine.components.bounds;
import engine.components.entitybehavior;
import engine.components.renderable;
import engine.spawn.spawner;
import engine.spawn.timedarea;
import dspace.behaviors.enemy;

enum EnemyType
{
    DRONE  = 0,
    SERAPH = 1
}

class EnemySpawner : TimedAreaSpawner
{
    private EnemyType type;

    this(EnemyType pType, FloatRect pSpawnArea)
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
        super(pSpawnArea, interval, details);
    }

    override void configureEntity(Entity entity, EntityDetails details)
    {
        super.configureEntity(entity, details);
        entity.add(new Bounds(17, 20));
        entity.add(new EntityBehavior(new EnemyBehavior()));
        if (type == EnemyType.DRONE) {
            entity.add(new Renderable(ResourceManager.getSprite("images/drone.png")));
        } else if (type == EnemyType.SERAPH) {
            entity.add(new Renderable(ResourceManager.getSprite("images/seraph.png")));
        }
    }
}