module dspace.core.collision.vector;

import std.conv;
import std.math;
import std.traits;

struct Vector
{
    float x;
    float y;

    @property
    {
        float length() const
        {
            return sqrt(dotProduct(this));
        }

        Vector unit() const
        {
            return Vector(x / length, y / length);
        }

        Vector rot90() const
        {
            return Vector(-y, x);
        }
    }

    float dotProduct(Vector v) const
    {
        return (x * v.x) + (y * v.y);
    }

    float project(Vector v) const
    {
        return dotProduct(v.unit);
    }

    Vector opUnary(string s)() const
    if (s == '-')
    {
        return Vector(-x, -y);
    }

    Vector opBinary(string op)(Vector v) const
    {
        return Vector(mixin("x" ~ op ~ "v.x"), mixin("y" ~ "v.y"));
    }

    Vector opBinary(string op, T)(T v) const
    if (isNumeric!(T))
    {
        return Vector(mixin("x" ~ op ~ "v"), mixin("y" ~ op ~ "v"));
    }

    ref Vector opOpAssign(string op)(Vector v)
    {
        x = mixin("x" ~ op ~ "v.x");
        y = mixin("y" ~ op ~ "v.y");
        return this;
    }

    ref Vector opOpAssign(string op, T)(T v)
    if (isNumeric!(T))
    {
        x = mixin("x" ~ op ~ "v");
        y = mixin("y" ~ op ~ "v");
        return this;
    }

    bool opEquals(const Vector v) const
    {
        return ((x == v.x) && (y == v.y));
    }

    string toString() const
    {
        return "(" ~ text(x) ~ "," ~ text(y) ~ ")";
    }
}