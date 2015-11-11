module engine.systems.controller;

import star.entity;

import engine.world;
import engine.components.controller;

class ControllerSystem : System
{
    protected World world;

    this(World _world)
    {
        world = _world;
    }

    void configure(EventManager events) { }

    void update(EntityManager entities, EventManager events, double delta)
    {
        foreach (entity; entities.entities!(EntityController)()) {
            auto controller = entity.component!(EntityController)().controller;
            controller.update(entity, world, delta);
        }
    }
}