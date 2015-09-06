module engine.systems.movement;

import dsfml.graphics;
import star.entity;

import engine.game;
import engine.components.bounds;
import engine.components.position;
import engine.components.velocity;

class MovementSystem : System
{
    RenderWindow window;

    this(RenderWindow pWindow)
    {
        window = pWindow;
    }

    void configure(EventManager events) { }

    void update(EntityManager entities, EventManager events, double delta)
    {
        foreach(entity; entities.entities!(Bounds, Position, Velocity)()) {
            auto bounds   = entity.component!(Bounds)();
            auto position = entity.component!(Position)();
            auto velocity = entity.component!(Velocity)();
            position.position += velocity.velocity * delta;

            if (bounds.keepInWindow) {
                auto container = window.getSize() - Vector2f(bounds.bounds.width, bounds.bounds.height);
                if (position.position.x < 0.0f) {
                    position.position.x = 0.0f;
                } else if (position.position.x > container.x) {
                    position.position.x = container.x;
                }
                if (position.position.y < 0.0f) {
                    position.position.y = 0.0f;
                } else if (position.position.y > container.y) {
                    position.position.y = container.y;
                }
            }
        }
    }
}