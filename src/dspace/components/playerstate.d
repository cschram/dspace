module dspace.components.playerstate;

import artemisd.all;

class PlayerState : Component
{
    mixin TypeDecl;

    float health;
    float maxHealth;

    this(float pHealth=10.0f, float pMaxHealth=10.0f)
    {
        health = pHealth;
        maxHealth = pMaxHealth;

        if (health > maxHealth) {
            health = maxHealth;
        }
    }
}