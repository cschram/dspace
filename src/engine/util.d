module engine.util;

import std.math;
import std.random;

import dsfml.graphics;

enum Direction
{
    UP     = 0,
    LEFT   = 1,
    DOWN   = 2,
    RIGHT  = 3
}

T[string] combineMap(T, D)(T[D][] args)
{
    T[D] result;
    foreach (map; args) {
        foreach (D key, T val; map) {
            result[key] = val;
        }
    }
    return result;
}

Vector2f getRandomPos(FloatRect area)
{
    float left, top;
    if (area.width <= 0) {
        left = area.left;
    } else {
        left = uniform(area.left, area.left + area.width);
    }
    if (area.height <= 0) {
        top = area.top;
    } else {
        top = uniform(area.top, area.top + area.height);
    }
    return Vector2f(left, top);
}

float degToRad(float d)
{
    return d * (PI / 180);
}

float radToDeg(float r)
{
    return r * (180 / PI);
}