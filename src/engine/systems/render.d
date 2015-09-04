module engine.systems.render;

import dsfml.graphics;
import star.entity;

import engine.components.position;
import engine.components.renderable;

class RenderSystem : System
{
    private RenderWindow window;

    this(RenderWindow pWindow)
    {
        window = pWindow;
    }

    void configure(EventManager events) { }

    void update(EntityManager entities, EventManager events, double delta)
    {
        foreach (entity; entities.entities!(Renderable)()) {
            auto position = entity.component!(Position)().position;
            auto target = entity.component!(Renderable)().target;
            auto renderState = RenderStates.Default;
            renderState.transform.translate(position.x, position.y);
            window.draw(target, renderState);
        }
    }
}