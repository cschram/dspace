module dspace.spawners.explosion;

import dsfml.audio;
import dsfml.graphics;
import star.entity;

import engine.components.position;
import engine.components.renderable;
import engine.graphics.animation;
import engine.spawn.spawner;

import dspace.controllers.animation;

class ExplosionSpawner : Spawner
{
    this(EntityManager pEntities)
    {
        super(pEntities);
    }

    override protected void configureEntity(Entity entity, EntityDetails details)
    {
        entity.add(new Renderable(Animation.loadFromFile("anim/explosion.anim")));
        //entity.add(new AnimationController());
    }
}