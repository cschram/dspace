module engine.systems.render;

import dsfml.graphics;
import star.entity;

import engine.game;
import engine.components.bounds;
import engine.components.position;
import engine.components.renderable;

class RenderSystem : System
{
    private RenderWindow window;

    this(Game game)
    {
        window = game.getWindow();
    }

    void configure(EventManager events) { }

    void update(EntityManager entities, EventManager events, double delta)
    {
        foreach (entity; entities.entities!(Bounds, Position, Renderable)()) {
            auto position = entity.component!(Position)().position;
            auto bounds = entity.component!(Bounds)().bounds;
            auto renderable = entity.component!(Renderable)();
            auto renderTarget = renderable.target;

            // Update animations
            if (renderable.anim !is null) {
                renderable.anim.update(delta);
            }
            if (renderable.animSet !is null) {
                renderable.animSet.update(delta);
            }

            // Translate render state by position
            auto renderState = RenderStates.Default;
            renderState.transform.translate(position.x, position.y);

            // Render
            window.draw(renderTarget, renderState);
        }
    }
}