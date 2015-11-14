module dspace.assemblies.drone;

import std.variant;

import engine.resourcemgr;
import engine.world;
import engine.components.controller;
import engine.components.physics;
import engine.components.renderable;
import dspace.controllers.enemy;

immutable Vector2f droneSize = Vector2f(17, 20);
immutable float droneSpeed = 150;
immutable string droneSpriteName = "images/drone.png";
immutable uint droneMaxHP = 1;

Entity droneAssembly(Entity drone, Variant[string] options)
{
    drone.add(new Physics(droneSize, Vector2f(0, droneSpeed)));
    drone.add(new Renderable(ResourceManager.getSprite(droneSpriteName)));
    drone.add(new EntityController(new EnemyController(droneMaxHP)));
    return drone;
}