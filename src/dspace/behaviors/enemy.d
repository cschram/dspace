module dspace.behaviors.enemy;

debug import std.stdio;

import dsfml.graphics;
import star.entity;

import engine.game;
import engine.behavior;
import engine.components.bounds;
import engine.components.position;

class EnemyBehavior : Behavior
{
    void update(Game game, Entity entity, float delta)
    {
        auto position = entity.component!(Position)().position;
        if (position.y > game.getWindow().getSize().y) {
            debug writeln("Destroying enemy");
            entity.destroy();
        }
    }
}