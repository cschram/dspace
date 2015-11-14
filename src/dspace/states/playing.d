module dspace.states.playing;

import dsfml.graphics;
import star.entity;

import engine.game;
import engine.resourcemgr;
import engine.world;
import engine.components.controller;
import engine.components.physics;
import engine.components.position;
import engine.components.renderable;
import engine.graphics.animationset;
import engine.spawn.timedarea;
import engine.states.state;
import engine.systems.controller;
import engine.systems.physics;
import engine.systems.render;
import dspace.controllers.enemy;
import dspace.controllers.player;
import dspace.spawners.enemy;

enum INIT_BG_POS = 1000;
enum SCROLL_SPEED = 30.0f;
enum INIT_PLAYER_POS = Vector2f(172.5, 539);

class PlayingState : State
{
    this(Game _game, RenderWindow _window, World _world)
    {
        game = _game;
        window = _window;
        world = _world;
        healthbar = ResourceManager.getSprite("images/healthbar.png");
    }

    bool enter(string prev)
    {
        backgroundPosition = INIT_BG_POS;
        player = world.spawn("player", INIT_PLAYER_POS);
        return (prev == "startmenu" || prev == "gameover");
    }

    bool exit(string next)
    {
        player = null;
        world.reset();
        return (next == "gameover");
    }

    void handleInput(Event e) { }

    void update(float delta)
    {
        auto health = (cast(PlayerController)player.component!EntityController().controller).getHealth();
        if (health <= 0) {
            game.setState("gameover");
            return;
        }

        if (backgroundPosition > 0) {
            backgroundPosition -= SCROLL_SPEED * delta;
            backgroundPosition = (backgroundPosition > 0) ? backgroundPosition : 0;
            background.textureRect = IntRect(0, cast(int)backgroundPosition, 400, 600);
        }

        window.clear();
        window.draw(world);
        healthbar.textureRect = IntRect(0, 0, 8 * health, 8);
        window.draw(healthbar);
        window.display();
    }

private:
    Game game;
    RenderWindow window;
    World world;
    Sprite healthbar;
    float backgroundPosition = 1000;
    Entity player;
}