module dspace.entities.seraph;

import std.variant;

import engine.resourcemgr;
import engine.world;
import engine.components.controller;
import engine.components.physics;
import engine.components.renderable;
import engine.graphics.spritesheet;
import dspace.controllers.enemy;

immutable Vector2f SERAPH_SIZE        = Vector2f(17, 20);
immutable float    SERAPH_SPEED       = 100;
immutable string   SERAPH_SPRITE_NAME = "images/seraph.png";
immutable uint     SERAPH_MAX_HEALTH  = 2;

Entity seraphAssembly(Entity seraph, Variant[string] options)
{
    seraph.add(new Physics(SERAPH_SIZE, Vector2f(0, SERAPH_SPEED)));
    seraph.add(new Renderable(ResourceManager.getSprite(SERAPH_SPRITE_NAME)));
    seraph.add(new EntityController(new EnemyController(SERAPH_MAX_HEALTH)));
    return seraph;
}