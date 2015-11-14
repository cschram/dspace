module dspace.assemblies.explosion;

import std.variant;

import engine.world;
import engine.components.controller;
import engine.components.renderable;
import engine.graphics.animation;
import dspace.controllers.animation;

immutable string explosionAnimName = "anim/explosion.anim";

Entity explosionAssembly(Entity explosion, Variant[string] options)
{
    explosion.add(new Renderable(Animation.loadFromFile(explosionAnimName)));
    explosion.add(new EntityController(new AnimationController()));
    return explosion;
}