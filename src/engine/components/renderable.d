module engine.components.renderable;

debug import std.stdio;
import dsfml.graphics;

import engine.graphics.animation;
import engine.graphics.animationset;

class Renderable
{
    Drawable     target;
    Animation    anim;
    AnimationSet animSet;

    this(Drawable pTarget)
    {
        target = pTarget;
    }

    this(Animation pAnimation)
    {
        target = pAnimation;
        anim   = pAnimation;
    }

    this(AnimationSet pAnimSet)
    {
        target  = pAnimSet;
        animSet = pAnimSet;
    }
}