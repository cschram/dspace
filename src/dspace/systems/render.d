module dspace.systems.render;

import std.stdio;

import artemisd.all;
import dsfml.graphics;

import dspace.core.game;
import dspace.components.dimensions;
import dspace.components.renderer;

class RenderSystem : EntityProcessingSystem
{
    mixin TypeDecl;

    Game         game;
    RenderWindow window;

    this(Game pGame)
    {
        game = pGame;
        window = game.getWindow();
        super(Aspect.getAspectForAll!(Dimensions, Renderer));
        writeln("RenderSystem initialized.");
    }

    override void begin()
    {
        window.clear();
        game.renderBackground();
    }

    override void end()
    {
        game.renderUI();
        window.display();
    }

    override void process(Entity e)
    {
        auto dim = e.getComponent!Dimensions;
        auto rend = e.getComponent!Renderer;
        if (rend.visible) {
            auto sprite = rend.target.getSprite();
            sprite.position = dim.position;
            window.draw(sprite);
        }
    }
}