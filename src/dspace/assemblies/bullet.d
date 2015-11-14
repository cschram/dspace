module dspace.assemblies.bullet;

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

immutable float bulletSpeed = 200;
immutable Vector2f bulletSize = Vector2f(4, 8);
immutable string bulletSpriteName = "images/bullets.png";

Entity bulletAssembly(Entity bullet, Variant[string] options)
{
    auto physics = new Physics(bulletSize);
    auto spritesheet = new SpriteSheet(ResourceManager.getSprite(bulletSpriteName), bulletSize);
    auto dir = cast(Direction)options["direction"];
    if (dir == Direction.UP) {
        spritesheet.setIndex(0);
        physics.velocity = Vector2f(0, -bulletSpeed);
    } else if (dir == Direction.DOWN) {
        spritesheet.setIndex(1);
        physics.velocity = Vector2f(0, bulletSize);
    }

    bullet.add(physics);
    bullet.add(new Renderable(spritesheet));
    bullet.add(new EntityController(new BulletController));

    return bullet;
}