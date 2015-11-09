module engine.vectorutils;

import std.math;

import dsfml.graphics;

import engine.util;

Direction direction(Vector2f v) pure nothrow @safe
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

float dot(Vector2f a, Vector2f b) pure nothrow @safe
{
    return (a.x * b.x) + (a.y * b.y);
}

float length(Vector2f v) pure nothrow @safe
{
    return sqrt(dot(v, v));
}

Vector2f unit(Vector2f v) pure nothrow @safe
{
    auto len = v.length;
    return Vector2f(v.x / len, v.y / len);
}

Vector2f rotate(Vector2f f, float r)
{
    return Vector2f(
        (f.x * cos(r)) - (f.y * sin(r)),
        (f.x * sin(r)) + (f.y * cos(r))
    );
}

Vector2f rotate90(Vector2f v) pure nothrow @safe
{
    return Vector2f(-v.y, v.x);
}

float project(Vector2f a, Vector2f b) pure nothrow @safe
{
    return dot(a, unit(b));
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

    assert(dot(Vector2f(1, 2), Vector2f(3, 4)) == 11);

    assert(length(Vector2f(3, 4)) == 5);

    assert(unit(Vector2f(3, 4)) == Vector2f(3.0 / 5.0, 4.0 / 5.0));

    assert(rotate(Vector2f(1, 0), PI) == Vector2f(-1, 0));

    assert(rotate90(Vector2f(1, 2)) == Vector2f(-2, 1));

    assert(project(Vector2f(1, 1), Vector2f(3, 4)) == Vector2f(3.0 / 5.0, 4.0 / 5.0));
}