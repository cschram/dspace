module dspace.spawners.bullet;

import dsfml.graphics;
import star.entity;

import engine.direction;
import engine.resourcemgr;
import engine.components.controller;
import engine.components.physics;
import engine.components.renderable;
import engine.graphics.spritesheet;
import engine.spawn.spawner;
import dspace.controllers.bullet;

class BulletSpawner : Spawner
{
    private immutable(float) speed = 200;

    private Direction direction;

    this(EntityManager entities, Direction pDirection)
    {
        super(entities);
        direction = pDirection;
    }

    override protected void configureEntity(Entity entity, EntityDetails details)
    {
        auto sprite = ResourceManager.getSprite("images/bullets.png");
        auto sheet = new SpriteSheet(sprite, Vector2i(4, 8));
        if (direction == Direction.UP) {
            details.velocity = Vector2f(0, -speed);
        } else if (direction == Direction.DOWN) {
            details.velocity = Vector2f(0, speed);
        }

        entity.add(new Renderable(sheet));
        entity.add(new EntityController(new BulletController()));

        super.configureEntity(entity, details);

        auto physics = entity.component!Physics();
        physics.size = Vector2f(4, 8);
    }
}