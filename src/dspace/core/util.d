module dspace.core.util;

import std.math;

import dsfml.graphics;

float dotProduct(Vector2f[] vectors...) {
    float sum = 0.0f;
    foreach (Vector2f vec; vectors) {
        sum += vec.x * vec.y;
    }
    return sum;
}

enum CollisionState {
    NO_COLLISION = 0,
    TOUCHING     = 1,
    OVERLAPPING  = 2
}

CollisionState checkCollision(FloatRect a, FloatRect b) {
    if (a.intersects(b)) {
        return CollisionState.OVERLAPPING;
    } else {
        return CollisionState.NO_COLLISION;
    }
}