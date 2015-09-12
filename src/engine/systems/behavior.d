module engine.systems.behavior;

import star.entity;

import engine.game;
import engine.components.entitybehavior;

class BehaviorSystem : System
{
    protected Game game;

    this(Game pGame)
    {
        game = pGame;
    }

    void configure(EventManager events) { }

    void update(EntityManager entities, EventManager events, double delta)
    {
        foreach (entity; entities.entities!(EntityBehavior)()) {
            auto behavior = entity.component!(EntityBehavior)().behavior;
            behavior.update(game, entity, delta);
        }
    }
}