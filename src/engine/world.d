module engine.world;

import std.variant;

import dsfml.graphics;
import star.entity;

import engine.util;
import engine.components.position;
import engine.systems.controller;
import engine.systems.physics;
import engine.systems.render;

alias EntityAssembly = Entity delegate(Entity, Variant[string]);

class World : Drawable
{
    Drawable background;

    this(EntityAssembly[string] _assemblies)
    {
        assemblies = _assemblies;

        engine = new Engine();
        engine.systems.add(new ControllerSystem(this));
        engine.systems.add(new PhysicsSystem(this));
        engine.systems.add(new RenderSystem(this));
        engine.systems.configure();
    }

    void empty() { engine.entities.clear(); }

    @property float delta() { return currentDelta; }

    Entity spawn(string factoryName, Vector2f position, Variant[string] options=[])
    {
        auto entity = engine.entities.create();
        entity.add(new Position(position));
        return factories[factoryName](entity, options);
    }

    void update(float d)
    {
        currentDelta = d;
        entityEngine.systems.update!(PhysicsSystem)(d);
        entityEngine.systems.update!(ControllerSystem)(d);
    }

    override void draw(RenderTarget target, RenderStates renderStates)
    {
        background.draw(target, renderStates);
        entityEngine.systems.update!(RenderSystem)(currentDelta);
    }

private:
    Engine engine;
    EntityAssembly[string] assemblies;
    float currentDelta;
}