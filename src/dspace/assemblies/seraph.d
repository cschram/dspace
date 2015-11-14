module dspace.assemblies.seraph;

import std.variant;

import engine.resourcemgr;
import engine.world;
import engine.components.controller;
import engine.components.physics;
import engine.components.renderable;
import engine.graphics.spritesheet;
import dspace.controllers.enemy;

immutable Vector2f seraphSize = Vector2f(17, 20);
immutable float seraphSpeed = 100;
immutable string seraphSpriteName = "images/seraph.png";
immutable uint seraphMaxHP = 2;

Entity seraphAssembly(Entity seraph, Variant[string] options)
{
    seraph.add(new Physics(seraphSize, Vector2f(0, seraphSpeed)));
    seraph.add(new Renderable(ResourceManager.getSprite(seraphSpriteName)));
    seraph.add(new EntityController(new EnemyController(seraphMaxHP)));
    return seraph;
}