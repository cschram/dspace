module dspace.systems.collision;

import std.stdio;
import std.algorithm;

import artemisd.all;
import dsfml.graphics;

import dspace.core.game;
import dspace.core.quadtree;
import dspace.core.util;
import dspace.components.dimensions;

class CollisionSystem : EntityProcessingSystem
{
    mixin TypeDecl;

    QuadTree     tree;
    Game         game;
    GroupManager groupMgr;

    this(Game pGame)
    {
        super(Aspect.getAspectForAll!(Dimensions));
        tree = new QuadTree(0, FloatRect(0, 0, cast(float)Game.screenMode.width, cast(float)Game.screenMode.height));
        game = pGame;
        groupMgr = pGame.getGroupMgr();
    }

    override void begin()
    {
        auto entities = groupMgr.getEntities("collidable");
        for (size_t i = 0; i < entities.size(); i++) {
            tree.insert(entities.get(i));
        }
    }

    override void end()
    {
        tree.clear();
    }

    override void process(Entity e)
    {
        auto dim = e.getComponent!Dimensions;
        auto rect = FloatRect(dim.position, dim.size);
        auto entities = tree.retrieve(rect);
        foreach (collider; entities) {
            if (collider == e || dim.collisionType == CollideType.NO_COLLIDE)
                continue;

            auto colliderDim = collider.getComponent!Dimensions;
            auto colliderRect = FloatRect(colliderDim.position, colliderDim.size);

            if (checkCollision(rect, colliderRect) == CollisionState.OVERLAPPING) {
                if (dim.collisionType == CollideType.BLOCK) {
                    colliderDim.position = colliderDim.lastPosition;
                } else if (dim.collisionType == CollideType.DAMAGE) {
                    game.hitEntity(collider, dim.collisionDamage);
                }
            }
        }
    }
}