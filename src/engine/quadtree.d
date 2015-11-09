module engine.quadtree;

import std.algorithm;
import std.range;

import dsfml.graphics;

class QuadTree(T)
{
    this(FloatRect _bounds, int _level=0)
    {
        bounds = _bounds;
        level = _level;
    }

    void clear() nothrow @safe
    {
        children = [];
        if (nodes.length > 0) {
            foreach(node; nodes) {
                node.clear();
            }
            nodes = [];
        }
    }

    void split() nothrow @safe
    {
        auto x = bounds.left;
        auto y = bounds.left;
        auto w = (bounds.width / 2);
        auto h = (bounds.height / 2);

        nodes = [
            // Top left
            new QuadTree(FloatRect(x, y, w, h), level + 1),
            // Top right
            new QuadTree(FloatRect(x + w, y, w, h), level + 1),
            // Bottom left
            new QuadTree(FloatRect(x, y + h, w, h), level + 1),
            // Bottom right
            new QuadTree(FloatRect(x + w, y + h, w, h), level + 1)
        ];
    }

    void insert(FloatRect itemBounds, T item) nothrow @safe
    {
        if (nodes.length > 0) {
            auto i = getIndex(itemBounds);

            if (i > -1) {
                nodes[i].insert(itemBounds, item);
                return;
            }
        }

        auto newChild = Child(itemBounds, item);
        children ~= newChild;

        if (children.length > maxChildren && level < maxLevels) {
            if (nodes.length == 0) {
                split();
            }

            int i = 0;
            while (i < children.length) {
                auto child = children[i];
                int index = getIndex(child.bounds);
                if (index > -1) {
                    nodes[index].insert(child.bounds, child.item);
                    children = children.remove(i);
                } else {
                    i++;
                }
            }
        }
    }

    auto retrieve(FloatRect searchArea) const nothrow @safe
    {
        auto inNode = map!(c => c.item)(children);
        auto i = getIndex(searchArea);
        if (i > -1 && quads.length > 0) {
            return chain(inNode, quads[i].retrieve(searchArea));
        } else {
            return inNode;
        }
    }

private:
    struct Child
    {
        FloatRect bounds;
        T item;
    }

    immutable(int) maxChildren = 10;
    immutable(int) maxLevels = 5;

    FloatRect bounds;
    int level;
    Child[] children;
    QuadTree[] quads;

    // Determine which subtree to place an object in.
    // If -1 is returned then it can't fit in any and belongs in the parent.
    int getIndex(FloatRect eBounds) const nothrow @safe
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
}