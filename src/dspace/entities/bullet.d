module dspace.entities.bullet;

import std.variant;

import engine.resourcemgr;
import engine.util;
import engine.vectorutils;
import engine.world;
import engine.components.controller;
import engine.components.physics;
import engine.components.renderable;
import engine.graphics.spritesheet;
import dspace.controllers.bullet;

immutable float BULLET_SPEED = 200;
immutable Vector2f BULLET_SIZE = Vector2f(4, 8);
immutable string BULLET_SPRITE_NAME = "images/bullets.png";

Entity bulletAssembly(Entity bullet, Variant[string] options)
{
    auto physics = new Physics(BULLET_SIZE);
    auto spritesheet = new SpriteSheet(ResourceManager.getSprite(BULLET_SPRITE_NAME), BULLET_SIZE);
    auto dir = cast(Direction)options["direction"];
    if (dir == Direction.UP) {
        spritesheet.setIndex(0);
        physics.velocity = Vector2f(0, -BULLET_SPEED);
    } else if (dir == Direction.DOWN) {
        spritesheet.setIndex(1);
        physics.velocity = Vector2f(0, BULLET_SIZE);
    }

    bullet.add(physics);
    bullet.add(new Renderable(spritesheet));
    bullet.add(new EntityController(new BulletController));

    return bullet;
}