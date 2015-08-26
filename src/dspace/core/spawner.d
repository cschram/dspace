module dspace.core.spawner;

import std.random;

import artemisd.all;
import dsfml.graphics;

import dspace.components.dimensions;
import dspace.components.renderer;
import dspace.components.velocity;
import dspace.core.game;
import dspace.core.resourcemgr;

/*****************************************************************************
 * Enemy Details
 * Static enemy information used for spawning.
 ****************************************************************************/
class EntityDetails
{
    const(string) typeName;
    Vector2f      size;
    const(string) animation;
    float         speed;

    this(const(string) pType, Vector2f pSize, const(string) pAnim, float pSpeed)
    {
        typeName = pType;
        size = pSize;
        animation = pAnim;
        speed = pSpeed;
    }
}

class Spawner
{
    protected World           world;
    protected ResourceManager resourceMgr;
    protected TagManager      tagMgr;
    protected GroupManager    groupMgr;
    private   EntityDetails   entityDetails;
    private   FloatRect       area;
    protected float           interval;
    private   float           timer = 0.0f;

    this(Game game, FloatRect pArea, float pInterval, EntityDetails pDetails)
    {
        world = game.getWorld();
        resourceMgr = game.getResourceMgr();
        tagMgr = game.getTagMgr();
        groupMgr = game.getGroupMgr();
        area = pArea;
        interval = pInterval;
        entityDetails = pDetails;

        area.width -= entityDetails.size.x;
        area.height -= entityDetails.size.y;
    }

    private Vector2f getRandomPos()
    {
        float left, top;
        if (area.width <= 0.0f) {
            left = area.left;
        } else {
            left = uniform(area.left, area.left + area.width);
        }
        if (area.height <= 0.0f) {
            top = area.top;
        } else {
            top = uniform(area.top, area.top + area.height);
        }
        return Vector2f(left, top);
    }

    protected void addComponents(Entity e, Vector2f pos)
    {
        e.addComponent(new Dimensions(pos, entityDetails.size));
        e.addComponent(new Renderer(resourceMgr.getAnimation(entityDetails.animation)));
        e.addComponent(new Velocity(Vector2f(0.0f, entityDetails.speed)));
    }

    protected Entity spawn()
    {
        auto entity = world.createEntity();
        addComponents(entity, getRandomPos());
        entity.addToWorld();
        groupMgr.add(entity, entityDetails.typeName);
        groupMgr.add(entity, "collidable");
        return entity;
    }

    float getInterval()
    {
        return interval;
    }

    void setInterval(float pInterval)
    {
        interval = pInterval;
    }

    final Entity tick(float delta)
    {
        timer += delta;
        if (timer >= interval) {
            timer = 0.0f;
            return spawn();
        }
        return null;
    }
}