module dspace.core.collision.quadtree;

import std.stdio;
import std.algorithm;

import dspace.core.collision.body;
import dspace.core.collision.rect;

class QuadTree
{
    private static immutable(int) maxChildren = 10;
    private static immutable(int) maxLevels   = 5;

    private int        level;
    private Body[]     children;
    private Rect       bounds;
    private QuadTree[] nodes;

    this(int pLevel, Rect pBounds)
    {
        level = pLevel;
        bounds = pBounds;
    }

    // Determine which subtree to place an object in.
    // If -1 is returned then it can't fit in any and belongs in the parent.
    private int getIndex(Rect pBounds) const
    {
        auto index = -1;
        // Vertical mid point
        auto vMid = bounds.x + (bounds.width / 2);
        // Horizontal mid point
        auto hMid = bounds.y + (bounds.height / 2);
        // Can fit entirely in the top quadrants
        auto topQuad = (pBounds.y < hMid && (pBounds.y + pBounds.height) < hMid);
        // Can fit entirely in the bottom quadrants
        auto bottomQuad = (pBounds.y > hMid);
        // Can fit entirely in the left quadrants
        auto leftQuad = (pBounds.x < vMid && (pBounds.x + pBounds.width) < vMid);
        // Can fit entirely in the right quadrants
        auto rightQuad = (pBounds.x > vMid);

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
        children = [];
        if (nodes.length > 0) {
            foreach(node; nodes) {
                node.clear();
            }
            nodes = [];
        }
    }

    void split()
    {
        auto x = bounds.x;
        auto y = bounds.x;
        auto w = (bounds.width / 2);
        auto h = (bounds.height / 2);

        nodes = [
            // Top left
            new QuadTree(level + 1, Rect(x, y, w, h)),
            // Top right
            new QuadTree(level + 1, Rect(x + w, y, w, h)),
            // Bottom left
            new QuadTree(level + 1, Rect(x, y + h, w, h)),
            // Bottom right
            new QuadTree(level + 1, Rect(x + w, y + h, w, h))
        ];
    }

    void insert(Body pBody)
    {
        if (nodes.length > 0) {
            auto i = getIndex(pBody.getBounds());

            if (i > -1) {
                nodes[i].insert(pBody);
                return;
            }
        }

        children ~= pBody;

        if (children.length > maxChildren && level < maxLevels) {
            if (nodes.length == 0) {
                split();
            }

            int i = 0;
            while (i < children.length) {
                auto child = children[i];
                int index = getIndex(child.getBounds());
                if (index > -1) {
                    nodes[index].insert(child);
                    children = children.remove(i);
                } else {
                    i++;
                }
            }
        }
    }

    Body[] retrieve(Rect pBounds)
    {
        int i = getIndex(pBounds);
        if (i > -1 && nodes.length > 0) {
            return nodes[i].retrieve(pBounds);
        }
        return children;
    }
}