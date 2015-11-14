module dspace.assemblies.player;

import std.variant;

import star.entity;

import engine.resourcemgr;
import engine.world;

immutable Vector2f playerSize = Vector2f(55, 61);
immutable string playerAnimName = "anim/player.animset";

Entity playerAssembly(Entity player, Variant[string] options)
{
    player.add(new Physics(playerSize,
                           Vector2f(0, 0),
                           Vector2f(0, 0),
                           CollisionMode.PASSIVE,
                           CollisionGroup.A,
                           CollisionGroup.BOTH,
                           true));
    player.add(new Renderable(AnimationSet.loadFromFile(playerAnimName)));
    player.add(new EntityController(new PlayerController));
    return player;
}