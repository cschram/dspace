module dspace.components.dimensions;

import dsfml.system;
import artemisd.all;

class Dimensions : Component {
    mixin TypeDecl;

    Vector2f position;
    Vector2f size;

    this(Vector2f position, Vector2f size) {
        this.position = position;
        this.size     = size;
    }
}