module dspace.entities.explosion;

import std.variant;

import engine.world;
import engine.components.controller;
import engine.components.renderable;
import engine.graphics.animation;
import dspace.controllers.animation;

immutable string EXPLOSION_ANIMATION_NAME = "anim/explosion.anim";

Entity explosionAssembly(Entity explosion, Variant[string] options)
{
    explosion.add(new Renderable(Animation.loadFromFile("anim/explosion.anim")));
    explosion.add(new EntityController(new AnimationController()));
    return explosion;
}