module engine.systems.physics;

debug import std.stdio;

import dsfml.graphics;
import star.entity;

import engine.configmgr;
import engine.quadtree;
import engine.components.controller;
import engine.components.physics;
import engine.components.position;

class PhysicsSystem : System
{
    this()
    {
        auto videoMode = ConfigManager.get().videoMode;
        windowSize = Vector2f(videoMode.width, videoMode.height);
        tree = new QuadTree!Entity(FloatRect(0, 0, windowSize.x, windowSize.y));
    }

    void configure(EventManager events) { }

    void moveEntities(EntityManager entities, float delta)
    {
        foreach (entity; entities.entities!(Physics, Position)()) {
            auto physics  = entity.component!Physics();
            auto position = entity.component!Position();
            position.lastPosition = position.position;
            position.position += physics.velocity * delta;

            if (physics.keepInWindow) {
                auto container = windowSize - physics.size + physics.offset;
                if (position.position.x < 0) {
                    position.position.x = 0;
                } else if (position.position.x > container.x) {
                    position.position.x = container.x;
                }
                if (position.position.y < 0) {
                    position.position.y = 0;
                } else if (position.position.y > container.y) {
                    position.position.y = container.y;
                }
            }

            tree.insert(physics.getBounds(position.position), entity);
        }
    }

    void checkCollision(Entity a, Entity b)
    {
        auto aPhysics  = a.component!Physics();
        auto bPhysics  = b.component!Physics();
        auto aPosition = a.component!Position();
        auto bPosition = b.component!Position();
        auto aBounds   = aPhysics.getBounds(aPosition.position);
        auto bBounds   = bPhysics.getBounds(bPosition.position);
        if (aBounds.intersects(bBounds)) {
            // Should probably resolve positions more intelligently than this
            if (aPhysics.collideWith == CollisionGroup.BOTH || aPhysics.collideWith == bPhysics.collisionGroup) {
                aPosition.position = aPosition.lastPosition;
                if (a.hasComponent!EntityController()) {
                    a.component!EntityController().controller.collide(a, b);
                }
            }
            if (bPhysics.collideWith == CollisionGroup.BOTH || bPhysics.collideWith == aPhysics.collisionGroup) {
                bPosition.position = bPosition.lastPosition;
                if (b.hasComponent!EntityController()) {
                    b.component!EntityController().controller.collide(b, a);
                }
            }
        }
    }

    void checkCollisions(EntityManager entities)
    {
        foreach (entity; entities.entities!(Physics, Position)()) {
            auto physics  = entity.component!Physics();
            auto position = entity.component!Position();
            if (physics.collisionMode != CollisionMode.NONE) {
                auto bounds = physics.getBounds(position.position);
                foreach (target; tree.retrieve(bounds)) {
                    if (target.id != entity.id && target.component!Physics().collisionMode != CollisionMode.NONE) {
                        checkCollision(entity, target);
                    }
                }
            }
        }
    }

    void update(EntityManager entities, EventManager events, double delta)
    {
        tree.clear();
        moveEntities(entities, delta);
        checkCollisions(entities);
    }

private:
    Vector2f windowSize;
    QuadTree!Entity tree;
}