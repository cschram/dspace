module dspace.components.entitystate;

import artemisd.all;

class EntityState : Component
{
    mixin TypeDecl;

    int health;
    int maxHealth;

    this(int maxHealth)
    {
        this.maxHealth = maxHealth;
        health = maxHealth;
    }
}