module engine.systems.physics;

import dsfml.graphics;
import star.entity;

import engine.game;
import engine.quadtree;
import engine.components.physics;
import engine.components.position;

class PhysicsSystem : System
{
    private RenderWindow    window;
    private QuadTree!Entity tree;

    this(Game game)
    {
        window = game.getWindow();
        auto size = window.getSize();
        tree = new QuadTree!Entity(FloatRect(0, 0, size.x, size.y));
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
                auto container = window.getSize() - physics.size + physics.offset;
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

    void update(EntityManager entities, EventManager events, double delta)
    {
        tree.clear();
        moveEntities(entities, delta);
    }
}