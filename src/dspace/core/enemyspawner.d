module dspace.core.enemyspawner;

import artemisd.all;
import dsfml.graphics;

import dspace.behaviors.enemybehavior;
import dspace.components.ai;
import dspace.components.dimensions;
import dspace.components.enemystate;
import dspace.core.game;
import dspace.core.spawner;

class EnemyDetails : EntityDetails
{
    float maxHealth;

    this(const(string) pType, Vector2f pSize, const(string) pAnim, float pSpeed, float pHealth)
    {
        super("enemy_" ~ pType, pSize, pAnim, pSpeed);
        maxHealth = pHealth;
    }
}

class EnemySpawner : Spawner
{
    static immutable(float) minInterval = 0.25f;

    protected EnemyDetails  enemyDetails;

    this(Game game, FloatRect pArea, float pInterval, EnemyDetails pDetails)
    {
        enemyDetails = pDetails;
        super(game, pArea, pInterval, pDetails);
    }

    override protected void addComponents(Entity e, Vector2f pos)
    {
        super.addComponents(e, pos);
        e.addComponent(new AI(new EnemyBehavior));
        e.addComponent(new EnemyState(enemyDetails.maxHealth, enemyDetails.maxHealth));

        // Set collision type
        auto dim = e.getComponent!Dimensions;
        dim.collisionType = CollideType.DAMAGE;
        dim.collisionDamage = enemyDetails.maxHealth;
    }

    override protected Entity spawn()
    {
        auto entity = super.spawn();
        groupMgr.add(entity, "enemy");
        return entity;
    }

    override void setInterval(float pInterval)
    {
        interval = pInterval;
        if (interval < minInterval) {
            interval = minInterval;
        }
    }
}