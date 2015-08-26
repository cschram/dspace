module dspace.components.ai;

import artemisd.all;

import dspace.core.behavior;

class AI : Component
{
    mixin TypeDecl;

    Behavior behavior;

    this(Behavior pBehavior)
    {
        behavior = pBehavior;
    }
}