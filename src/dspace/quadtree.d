module dspace.quadtree;

import std.algorithm;
import dsfml.graphics;
import dspace.entity;

class QuadTree
{
    private static immutable(int) maxObjects = 10;
    private static immutable(int) maxLevels  = 5;

    private int        level;
    private Entity[]   entities;
    private FloatRect  bounds;
    private QuadTree[] nodes;

    this(int pLevel, FloatRect pBounds)
    {
        level = pLevel;
        bounds = pBounds;
    }

    // Determine which subtree to place an object in.
    // If -1 is returned then it can't fit in any and belongs in the parent.
    private int getIndex(FloatRect eBounds) const
    {
        auto index = -1;
        // Vertical mid point
        auto vMid = bounds.left + (bounds.width / 2);
        // Horizontal mid point
        auto hMid = bounds.top + (bounds.height / 2);
        // Can fit entirely in the top quadrants
        auto topQuad = (eBounds.top < hMid && (eBounds.top + eBounds.height) < hMid);
        // Can fit entirely in the bottom quadrants
        auto bottomQuad = (eBounds.top > hMid);
        // Can fit entirely in the left quadrants
        auto leftQuad = (eBounds.left < vMid && (eBounds.left + eBounds.width) < vMid);
        // Can fit entirely in the right quadrants
        auto rightQuad = (eBounds.left > vMid);

        if (topQuad) {
            if (leftQuad) {
                index = 0;
            } else if (rightQuad) {
                index = 1;
            }
        } else if (bottomQuad) {
            if (leftQuad) {
                index = 2;
            } else if (rightQuad) {
                index = 3;
            }
        }

        return index;
    }

    void clear()
    {
        entities = [];
        if (nodes.length > 0) {
            foreach(node; nodes) {
                node.clear();
            }
            nodes = [];
        }
    }

    void split()
    {
        auto x = bounds.left;
        auto y = bounds.left;
        auto w = (bounds.width / 2);
        auto h = (bounds.height / 2);

        nodes = [
            // Top left
            new QuadTree(level + 1, FloatRect(x, y, w, h)),
            // Top right
            new QuadTree(level + 1, FloatRect(x + w, y, w, h)),
            // Bottom left
            new QuadTree(level + 1, FloatRect(x, y + h, w, h)),
            // Bottom right
            new QuadTree(level + 1, FloatRect(x + w, y + h, w, h))
        ];
    }

    void insert(Entity e)
    {
        FloatRect eBounds = e.getBounds();
        if (nodes.length > 0) {
            auto i = getIndex(eBounds);

            if (i > -1) {
                nodes[i].insert(e);
                return;
            }
        }

        entities ~= e;

        if (entities.length > maxObjects && level < maxLevels) {
            if (nodes.length == 0) {
                split();
            }

            int i = 0;
            while (i < entities.length) {
                int index = getIndex(entities[i].getBounds());
                if (index > -1) {
                    nodes[index].insert(e);
                    nodes = remove(nodes, i);
                } else {
                    i++;
                }
            }
        }
    }

    Entity[] retrieve(FloatRect pRect)
    {
        int i = getIndex(pRect);
        if (i > -1 && nodes.length > 0) {
            return nodes[i].retrieve(pRect);
        }
        return entities;
    }
}