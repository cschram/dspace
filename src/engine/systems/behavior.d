module engine.systems.behavior;

debug import std.stdio;

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
        debug writeln("Test");
        foreach (entity; entities.entities!(EntityBehavior)()) {
            auto behavior = entity.component!(EntityBehavior)().behavior;
            behavior.update(game, entity, delta);
        }
    }
}