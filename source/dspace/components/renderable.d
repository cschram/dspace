module dspace.components.renderable;

import dsfml.graphics;
import artemisd.all;

class Renderable : Component {
    mixin TypeDecl;

    Drawable target;

    this(Drawable target) {
        this.target = target;
    }
}