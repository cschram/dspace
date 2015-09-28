module engine.systems.controller;

import star.entity;

import engine.game;
import engine.components.controller;

class ControllerSystem : System
{
    protected Game game;

    this(Game pGame)
    {
        game = pGame;
    }

    void configure(EventManager events) { }

    void update(EntityManager entities, EventManager events, double delta)
    {
        foreach (entity; entities.entities!(EntityController)()) {
            auto controller = entity.component!(EntityController)().controller;
            controller.update(entity, game, delta);
        }
    }
}