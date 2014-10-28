module dspace.entities.player;

import dsfml.graphics;
import dspace.entity;
import dspace.game;

class Player : Entity
{
    private uint health = 10;

    this(Vector2f pos)
    {
        size = Vector2f(55, 61);
        auto game = Game.getInstance();
        auto resourceMgr = game.getResourceMgr();
        sprite = resourceMgr.getSprite("images/ship.png");
        sprite.textureRect = IntRect(165, 0, 55, 61);
        super(pos);
    }

    uint getHealth()
    {
        return health;
    }

    void setVelocity(Vector2f vel)
    {
        velocity = vel;
    }

    override void update(float delta)
    {
        super.update(delta);
        float xMax = Game.screenMode.width - size.x;
        float yMax = Game.screenMode.height - size.y;
        if (position.x < 0) {
            position.x = 0;
        } else if (position.x > xMax) {
            position.x = xMax;
        }
        if (position.y < 0) {
            position.y = 0;
        } else if (position.y > yMax) {
            position.y = yMax;
        }
    }
}