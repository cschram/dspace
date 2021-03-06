module engine.util.vector;

import std.math;

import dsfml.system;

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