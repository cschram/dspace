module engine.behaviors.behavior;

import star.entity;

interface Behavior
{
    bool update(Engine engine, float delta);
}