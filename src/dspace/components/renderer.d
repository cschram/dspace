module dspace.components.renderer;

import artemisd.all;
import dsfml.graphics;

import dspace.core.renderable;

class Renderer : Component
{
    mixin TypeDecl;

    Renderable target;
    bool       visible;

    this(Renderable pTarget, bool pVisible=true)
    {
        target = pTarget;
        visible = pVisible;
    }
}