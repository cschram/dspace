module dspace.entities.drone;

import std.variant;

import engine.resourcemgr;
import engine.world;
import engine.components.controller;
import engine.components.physics;
import engine.components.renderable;
import dspace.controllers.enemy;

immutable Vector2f DRONE_SIZE        = Vector2f(17, 20);
immutable float    DRONE_SPEED       = 150;
immutable string   DRONE_SPRITE_NAME = "images/drone.png";
immutable uint     DRONE_MAX_HEALTH  = 1;

Entity droneAssembly(Entity drone, Variant[string] options)
{
    drone.add(new Physics(DRONE_SIZE, Vector2f(0, DRONE_SPEED)));
    drone.add(new Renderable(ResourceManager.getSprite(DRONE_SPRITE_NAME)));
    drone.add(new EntityController(new EnemyController(DRONE_MAX_HEALTH)));
    return drone;
}