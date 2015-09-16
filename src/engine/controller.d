module engine.controller;

import star.entity;

import engine.game;

interface Controller
{
    void update(Game game, Entity entity, float delta);
}