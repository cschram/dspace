module dspace.core.enemyspawner;

import artemisd.all;
import dsfml.graphics;

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
        e.addComponent(new EnemyState(enemyDetails.maxHealth, enemyDetails.maxHealth));
    }

    override protected Entity spawn()
    {
        auto entity = super.spawn();
        tagMgr.register("enemy", entity);
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