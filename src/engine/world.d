module engine.world;

import dsfml.graphics;
import star.entity;

import engine.util;
import engine.components.physics;
import engine.components.position;
import engine.components.renderable;
import engine.systems.controller;
import engine.systems.physics;
import engine.systems.render;

alias PlayerSetup = void delegate(Entity);
alias VarMap      = Variant[string];
alias PostSpawn   = void delegate(Entity, VarMap);

struct EntityTemplate
{
    Physics    physics;
    Renderable renderable;
    VarMap     defaultOptions;
    PostSpawn  callback;
}

struct SpawnParams
{
    Vector2f position;
    Vector2f velocity;
    VarMap   options;
}

class World : Drawable
{
    // NOTE: This could potentially be set to another instance of World. Possibly not
    // ideal, but likely shouldn't break anything.
    Drawable background;

    this(Game game)
    {
        engine = new Engine();
        engine.systems.add(new ControllerSystem(game));
        engine.systems.add(new PhysicsSystem(game));
        engine.systems.add(new RenderSystem(game));
        engine.systems.configure();
    }

    void reset() { engine.entities.clear(); }

    void addEntityTemplate(string name, EntityTemplate tpl) { entityTemplates[name] = tpl; }

    Entity spawn(string name, SpawnParams params)
    in
    {
        assert(name in entityTemplates);
    }
    body
    {
        auto entity = engine.entities.create();
        setupEntity(entity, params, entityTemplates[name]);
        return entity;
    }

    Entity spawn(string name, Vector2f position, Vector2f velocity=Vector2f(0,0))
    {
        return spawn(name, SpawnParams(position, velocity));
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
    Engine                 engine;
    EntityTemplate[string] entityTemplates;
    float                  currentDelta;

    void setupEntity(Entity entity, SpawnParams params, EntityTemplate tpl)
    {
        auto physics = new Physics(tpl.physics);
        physics.velocity = params.velocity;
        entity.add(physics);
        entity.add(new Position(params.position));
        if (tpl.renderable !is null) {
            entity.add(new Renderable(tpl.renderable));
        }
        if (tpl.callback !is null) {
            tpl.callback(entity, combineMap(tpl.defaultOptions, params.options));
        }
    }
}