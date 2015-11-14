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

    this(RenderWindow _window, EntityAssembly[string] _assemblies)
    {
        assemblies = _assemblies;

        engine = new Engine();
        engine.systems.add(new ControllerSystem(this));
        engine.systems.add(new PhysicsSystem());
        engine.systems.add(new RenderSystem(_window));
        engine.systems.configure();
    }

    void reset() { engine.entities.clear(); }

    Entity spawn(string factoryName, Vector2f position, Variant[string] options=[])
    {
        auto entity = engine.entities.create();
        entity.add(new Position(position));
        return factories[factoryName](entity, options);
    }

    void update(float delta)
    {
        currentDelta = delta;
        entityEngine.systems.update!(PhysicsSystem)(delta);
        entityEngine.systems.update!(ControllerSystem)(delta);
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