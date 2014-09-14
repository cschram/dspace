module dspace.components.velocity;

import dsfml.system;
import artemisd.all;

class Velocity : Component {
    mixin TypeDecl;

    Vector2f vel;
    bool     keepInBounds;

    this(bool keepInBounds=false) {
        this.vel          = Vector2f(0, 0);
        this.keepInBounds = keepInBounds;
    }
}