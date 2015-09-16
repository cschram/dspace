module engine.direction;

import std.math : abs;

import dsfml.system;

enum Direction
{
    UP     = 0,
    LEFT   = 1,
    DOWN   = 2,
    RIGHT  = 3
}

Direction vectorDirection(Vector2f v) pure nothrow @safe
{
    if (abs(v.x) > abs(v.y)) {
        if (v.x > 0) {
            return Direction.RIGHT;
        } else {
            return Direction.LEFT;
        }
    } else {
        if (v.y > 0) {
            return Direction.DOWN;
        } else {
            return Direction.UP;
        }
    }
}

unittest
{
    assert(vectorDirection(Vector2f(0, 0))     == Direction.UP);
    assert(vectorDirection(Vector2f(-1, -1))   == Direction.UP);
    assert(vectorDirection(Vector2f(0, -1))    == Direction.UP);
    assert(vectorDirection(Vector2f(0.5, -1))  == Direction.UP);
    assert(vectorDirection(Vector2f(-0.5, -1)) == Direction.UP);
    assert(vectorDirection(Vector2f(-1, 0))    == Direction.LEFT);
    assert(vectorDirection(Vector2f(-1, 0.5))  == Direction.LEFT);
    assert(vectorDirection(Vector2f(-1, -0.5)) == Direction.LEFT);
    assert(vectorDirection(Vector2f(1, 0))     == Direction.RIGHT);
    assert(vectorDirection(Vector2f(1, 0.5))   == Direction.RIGHT);
    assert(vectorDirection(Vector2f(1, -0.5))  == Direction.RIGHT);
    assert(vectorDirection(Vector2f(0, 1))     == Direction.DOWN);
    assert(vectorDirection(Vector2f(0.5, 1))   == Direction.DOWN);
    assert(vectorDirection(Vector2f(-0.5, 1))  == Direction.DOWN);
    assert(vectorDirection(Vector2f(1, 1))     == Direction.DOWN);
}