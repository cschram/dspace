module engine.behavior;

import star.entity;

import engine.game;

interface Behavior
{
    void update(Game game, Entity entity, float delta);
}