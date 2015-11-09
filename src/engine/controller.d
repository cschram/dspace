module engine.controller;

import star.entity;

import engine.world;

interface Controller
{
    void collide(Entity entity, Entity target);
    void update(Entity entity, World world);
}