module dspace.components.enemystate;

import artemisd.all;

class EnemyState : Component
{
    mixin TypeDecl;

    float health;
    float maxHealth;

    this(float pHealth=1.0f, float pMaxHealth=1.0f)
    {
        health = pHealth;
        maxHealth = pMaxHealth;

        if (health > maxHealth) {
            health = maxHealth;
        }
    }
}