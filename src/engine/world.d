module engine.world;

import dsfml.graphics;
import star.entity;

import engine.spawn.spawner;
import engine.systems.controller;
import engine.systems.physics;
import engine.systems.render;

alias PlayerSetup = void delegate(Entity);

class World : Drawable
{
    private Engine          engine;
    private Drawable        background;
    private Entity          player;
    private Spawner[string] spawners;
    private PlayerSetup     playerSetup;
    private float           currentDelta;

    this(Game game, PlayerSetup pPlayerSetup)
    {
        engine = new Engine();
        engine.systems.add(new ControllerSystem(game));
        engine.systems.add(new PhysicsSystem(game));
        engine.systems.add(new RenderSystem(game));
        engine.systems.configure();

        playerSetup = pPlayerSetup;
        player      = engine.entities.create();
        playerSetup(player);
    }

    void reset()
    {
        engine.entities.clear();
        player = engine.entities.create();
        playerSetup(player);
    }

    Entity getPlayer()
    {
        return player;
    }

    void setBackground(Drawable bg)
    {
        background = bg;
    }

    Drawable getBackground()
    {
        return background;
    }

    void addSpawner(string name, Spawner spawner)
    {
        spawners[name] = spawner;
    }

    Entity spawn(string name, EntityDetails details)
    {
        return spawners[name].spawn(engine.entities, details);
    }

    Entity spawn(string name, Vector2f position, Vector2f velocity=Vector2f(0,0))
    {
        return spawners[name].spawn(engine.entities, EntityDetails(position, velocity));
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
}