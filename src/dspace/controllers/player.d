module dspace.controllers.player;

import dsfml.window;
import star.entity;

import engine.controller;
import engine.direction;
import engine.game;
import engine.components.physics;
import engine.components.position;
import engine.components.renderable;
import engine.spawn.spawner;
import dspace.spawners.bullet;

class PlayerController : Controller
{
    private immutable(float) playerSpeed   = 250;
    private immutable(float) shootCooldown = 0.1;

    private BulletSpawner bulletSpawner;
    private float         shootCooldownTimer = 0.1;

    this(EntityManager entities)
    {
        bulletSpawner = new BulletSpawner(entities, Direction.UP);
    }

    void update(Game game, Entity entity, float delta)
    {
        auto physics = entity.component!Physics();
        auto animSet = entity.component!Renderable().animSet;

        if (Keyboard.isKeyPressed(Keyboard.Key.Left)) {
            physics.velocity.x = -playerSpeed;
            animSet.setAnimation("bank-left");
        } else if (Keyboard.isKeyPressed(Keyboard.Key.Right)) {
            physics.velocity.x = playerSpeed;
            animSet.setAnimation("bank-right");
        } else {
            physics.velocity.x = 0;
            animSet.setAnimation("idle");
        }

        if (shootCooldownTimer <= 0) {
            if (Keyboard.isKeyPressed(Keyboard.Key.Space)) {
                auto playerPos = entity.component!Position().position;
                bulletSpawner.spawn(EntityDetails(playerPos + Vector2f(27, -8)));
                shootCooldownTimer = shootCooldown;
            }
        } else {
            shootCooldownTimer -= delta;
        }
    }
}