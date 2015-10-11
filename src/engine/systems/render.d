module engine.systems.render;

import dsfml.graphics;
import star.entity;

import engine.game;
import engine.components.position;
import engine.components.renderable;

debug {
    import std.conv;
    import std.string;
    import std.math : round;
    import engine.resourcemgr;

    immutable(Vector2f) debugInfoPosition = Vector2f(0, 10);
}

class RenderSystem : System
{
    private RenderWindow window;

    debug {
        private float fps = 60;
        private Text  fpsText;
        private Text  objectsText;
    }

    this(Game game)
    {
        window = game.getWindow();

        debug {
            auto font = ResourceManager.getFont("fonts/OpenSans-Regular.ttf");
            fpsText = new Text("FPS: 0", font, 14);
            fpsText.position = debugInfoPosition;
            objectsText = new Text("Objects: 0", font, 14);
            objectsText.position = debugInfoPosition + Vector2f(0, 16);
        }
    }

    void configure(EventManager events) { }

    void update(EntityManager entities, EventManager events, double delta)
    {
        debug {
            int renderedCount = 0;
            fps = (fps * 0.9) + ((1 / delta) * 0.1);
            fpsText.setString(to!dstring(format("FPS: %s", round(fps))));
        }

        foreach (entity; entities.entities!(Position, Renderable)()) {
            auto position = entity.component!(Position)().position;
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

            debug renderedCount++;
        }

        debug {
            objectsText.setString(to!dstring(format("Objects: %s", renderedCount)));
            window.draw(fpsText);
            window.draw(objectsText);
        }
    }
}