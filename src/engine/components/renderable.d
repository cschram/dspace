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

    this(Renderable pTarget)
    {
        target = pTarget.target;
        if (pTarget.anim !is null) {
            anim = pTarget.anim;
        } else if (pTarget.animSet !is null) {
            animSet = pTarget.animSet;
        }
    }
}