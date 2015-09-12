module engine.components.entitybehavior;

import engine.behavior;

class EntityBehavior
{
    Behavior behavior;

    this(Behavior pBehavior)
    {
        behavior = pBehavior;
    }

    invariant
    {
        assert(behavior !is null);
    }
}