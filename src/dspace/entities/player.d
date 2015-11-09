module dspace.entities.player;

import std.variant;

import star.entity;

import engine.resourcemgr;
import engine.world;

immutable Vector2f PLAYER_SIZE = Vector2f(55, 61);
immutable string PLAYER_ANIM_NAME = "anim/player.animset";

Entity playerAssembly(Entity player, Variant[string] options)
{
    player.add(new Physics(PLAYER_SIZE,
                           Vector2f(0, 0),
                           Vector2f(0, 0),
                           CollisionMode.PASSIVE,
                           CollisionGroup.A,
                           CollisionGroup.BOTH,
                           true));
    player.add(new Renderable(AnimationSet.loadFromFile(PLAYER_ANIM_NAME)));
    player.add(new EntityController(new PlayerController));
    return player;
}