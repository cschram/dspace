module dspace.states.playing;

import dsfml.graphics;
import star.entity;

import engine.game;
import engine.resourcemgr;
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

class PlayingState : State
{
    private static immutable(float) scrollSpeed = 30;

    private Game               game;
    private RenderWindow       window;
    private Engine             entityEngine;
    private Sprite             background;
    private float              backgroundPosition = 1000;
    private Entity             player;
    private AnimationSet       playerAnimSet;
    private TimedAreaSpawner[] timedSpawners;

    this(Game pGame)
    {
        game         = pGame;
        window       = game.getWindow();
        entityEngine = new Engine();
        entityEngine.systems.add(new ControllerSystem(game));
        entityEngine.systems.add(new PhysicsSystem(game));
        entityEngine.systems.add(new RenderSystem(game));
        entityEngine.systems.configure();

        background = ResourceManager.getSprite("images/background.png");
        background.textureRect = IntRect(0, cast(int)backgroundPosition, 400, 600);

        createPlayer();
        createSpawners();
    }

    void createPlayer()
    {
        player        = entityEngine.entities.create();
        playerAnimSet = ResourceManager.getAnimationSet("anim/player.animset");

        player.add(new Physics(Vector2f(55, 61),
                               Vector2f(0, 0),
                               Vector2f(0, 0),
                               CollisionMode.PASSIVE,
                               CollisionGroup.A,
                               CollisionGroup.BOTH,
                               true));
        player.add(new Position(172.5, 539));
        player.add(new Renderable(playerAnimSet));
        player.add(new EntityController(new PlayerController(entityEngine.entities)));
    }

    void createSpawners()
    {
        auto spawnArea = FloatRect(0, -20, window.getSize().x, 0);
        timedSpawners ~= new EnemySpawner(entityEngine.entities, EnemyType.DRONE,  spawnArea);
        timedSpawners ~= new EnemySpawner(entityEngine.entities, EnemyType.SERAPH, spawnArea);
    }

    bool enter(string prev)
    {
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
            backgroundPosition -= scrollSpeed * delta;
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
        window.display();
    }
}