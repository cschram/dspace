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

enum SCROLL_SPEED = 30.0f;

class PlayingState : State
{
    this(Game _game)
    {
        game   = _game;
        window = game.getWindow();
        createWorld(&this.setupPlayer);

        background = ResourceManager.getSprite("images/background.png");
        background.textureRect = IntRect(0, cast(int)backgroundPosition, 400, 600);
        healthbar = ResourceManager.getSprite("images/healthbar.png");
    }

    bool enter(string prev)
    {
        if (prev == "gameover") {
            entityEngine.entities.clear();
            createPlayer();
            foreach (spawner; timedSpawners) {
                spawner.resetInterval();
            }
        }
        return (prev == "startmenu" || prev == "gameover");
    }

    bool exit(string next)
    {
        return (next == "gameover");
    }

    void handleInput(Event e) { }

    void update(float delta)
    {
        if (backgroundPosition > 0) {
            backgroundPosition -= SCROLL_SPEED * delta;
            backgroundPosition = (backgroundPosition > 0) ? backgroundPosition : 0;
            background.textureRect = IntRect(0, cast(int)backgroundPosition, 400, 600);
        }

        foreach (spawner; timedSpawners) {
            spawner.update(delta);
            auto interval = spawner.getInterval();
            if (interval > TimedAreaSpawner.minInterval) {
                spawner.setInterval(interval - (delta / 10));
            }
        }

        entityEngine.systems.update!(PhysicsSystem)(delta);
        entityEngine.systems.update!(ControllerSystem)(delta);

        window.clear();
        window.draw(background);
        entityEngine.systems.update!(RenderSystem)(delta);

        auto health = (cast(PlayerController)player.component!EntityController().controller).getHealth();
        healthbar.textureRect = IntRect(0, 0, 8 * health, 8);
        window.draw(healthbar);

        window.display();
    }

private:
    Game game;
    RenderWindow window;
    Sprite background;
    Sprite healthbar;
    float backgroundPosition = 1000;
    Entity player;
    TimedAreaSpawner[] timedSpawners;
}