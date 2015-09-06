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
            auto renderable = entity.component!(Renderable)();
            auto renderTarget = renderable.target;

            // Update animations
            if (renderable.anim !is null) {
                renderable.anim.tick(delta);
            }
            if (renderable.animSet !is null) {
                renderable.animSet.tick(delta);
            }

            // Translate render state by position
            auto renderState = RenderStates.Default;
            renderState.transform.translate(position.x, position.y);

            // Render
            window.draw(renderTarget, renderState);
        }
    }
}