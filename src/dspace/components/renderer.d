module dspace.components.renderer;

import artemisd.all;
import dsfml.graphics;

import dspace.core.renderable;

class Renderer : Component
{
    mixin TypeDecl;

    Renderable target;
    bool       visible;
    bool       hideOnComplete;
    bool       destroyOnComplete; // XXX: Should not be dictated by this component, needs to be moved elsewhere

    this(Renderable pTarget, bool pVisible=true, bool pHide=false, bool pDestroy=false)
    {
        target = pTarget;
        visible = pVisible;
        hideOnComplete = pHide;
        destroyOnComplete = pDestroy;
    }
}