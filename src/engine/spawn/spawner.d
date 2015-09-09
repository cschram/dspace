module engine.spawn.spawner;

import dsfml.system;
import star.entity;

import engine.components.position;
import engine.components.velocity;

struct EntityDetails
{
    Vector2f position;
    Vector2f velocity;
}

class Spawner
{
    protected void configureEntity(Entity entity, EntityDetails details)
    {
        entity.add(new Position(details.position));
        entity.add(new Velocity(details.velocity));
    }

    final Entity spawn(EntityManager entities, EntityDetails details)
    {
        auto entity = entities.create();
        configureEntity(entity, details);
        return entity;
    }
}