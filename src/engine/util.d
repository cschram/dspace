module engine.util;

import std.math;
import std.random;

import dsfml.graphics;

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

float dotProduct(Vector2f a, Vector2f b)
{
    return (a.x * b.x) + (a.y * b.y);
}

float vectorLength(Vector2f v)
{
    return sqrt(dotProduct(v, v));
}

Vector2f vectorUnit(Vector2f v)
{
    auto len = vectorLength(v);
    return Vector2f(v.x / len, v.y / len);
}

Vector2f rotateVector90(Vector2f v)
{
    return Vector2f(-v.y, v.x);
}

float projectVector(Vector2f a, Vector2f b)
{
    return dotProduct(a, vectorUnit(b));
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