module engine.spawn.spawner;

import dsfml.system;
import star.entity;

import engine.components.physics;
import engine.components.position;

struct EntityDetails
{
    Vector2f position;
    Vector2f velocity;
}

class Spawner
{
    private EntityManager entities;

    this(EntityManager pEntities)
    {
        entities = pEntities;
    }

    protected void configureEntity(Entity entity, EntityDetails details)
    {
        entity.add(new Physics(Vector2f(0, 0), Vector2f(0, 0), details.velocity));
        entity.add(new Position(details.position));
    }

    final Entity spawn(EntityDetails details)
    {
        auto entity = entities.create();
        configureEntity(entity, details);
        return entity;
    }
}