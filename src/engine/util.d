module engine.util;

import std.math;
import std.random;

import dsfml.graphics;

enum Direction
{
    UP,
    LEFT,
    DOWN,
    RIGHT
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