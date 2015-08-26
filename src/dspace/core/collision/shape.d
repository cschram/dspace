module dspace.core.collision.shape;

import std.math;
import std.traits;

import dspace.core.collision.projection;
import dspace.core.collision.vector;

class Shape
{
    protected Vector[] vertices;

    @property
    {
        Vector[] edges() const
        {
            Vector[] e;
            for (auto i = 0; i < vertices.length; i++) {
                e ~= vertices[(i + 1) % vertices.length] - vertices[i];
            }
            return e;
        }

        Vector[] normals() const
        {
            Vector[] n;
            foreach (edge; edges) {
                n ~= edge.rot90;
            }
            return n;
        }
    }

    this(Vector[] pVertices)
    {
        vertices = pVertices;
    }

    void translate(Vector translationVector)
    {
        foreach (vertex; vertices) {
            vertex += translationVector;
        }
    }

    void translate(T)(T value)
    if (isNumeric!(T))
    {
        foreach (vertex; vertices) {
            vertex += value;
        }
    }

    Projection project(Vector axis) const
    {
        Projection proj;
        bool first = true;
        foreach (v; vertices) {
            auto p = v.project(axis);
            if (first) {
                proj.start = p;
                proj.end = p;
                first = false;
            } else {
                if (p < proj.start) {
                    proj.start = p;
                }
                if (p > proj.end) {
                    proj.end = p;
                }
            }
        }
        return proj;
    }

    Vector checkCollision(Shape other) const
    {
        auto axes = normals ~ other.normals;
        auto minOffset = float.infinity;
        Vector minTranslation;

        foreach (axis; axes) {
            auto p1 = project(axis);
            auto p2 = other.project(axis);
            auto offset = p1.overlap(p2);

            if (offset == 0) {
                return Vector(0, 0);
            }

            if (abs(offset) < minOffset) {
                minOffset = abs(offset);
                minTranslation = axis * offset;
            }
        }

        return minTranslation.rot90.rot90;
    }
}