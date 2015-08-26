module dspace.core.collision.rect;

import dspace.core.collision.shape;
import dspace.core.collision.vector;

class Rect : Shape
{
    protected Vector size;

    this(Vector position, Vector pSize)
    {
        vertices = [
            position,
            Vector(position.x + pSize.x, position.y),
            position + pSize,
            Vector(position.x, position.y + pSize.y)
        ];
        size = pSize;
    }

    this(float x, float y, float w, float h)
    {
        this(Vector(x, y), Vector(w, h));
    }

    @property
    {
        override Vector[] normals() const
        {
            Vector[] n;
            for (auto i = 0; i < edges.length; i++) {
                n ~= edges[i].rot90;
            }
            return n;
        }

        float x() const
        {
            return vertices[0].x;
        }

        float y() const
        {
            return vertices[0].y;
        }

        float width() const
        {
            return size.x;
        }

        float height() const
        {
            return size.y;
        }
    }
}