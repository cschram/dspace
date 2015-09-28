module engine.controller;

import star.entity;

import engine.game;

interface Controller
{
    void collide(Entity entity, Entity target);
    void update(Entity entity, Game game, float delta);
}