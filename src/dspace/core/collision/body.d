module dspace.core.collision.body;

import dspace.core.collision.rect;

interface Body
{
    Rect getBounds() const;
}