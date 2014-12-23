module dspace.states.game.playing;

import std.stdio;
import std.conv;
import std.string;

import artemisd.all;
import dsfml.graphics;

import dspace.components.dimensions;
import dspace.components.playerstate;
import dspace.components.renderer;
import dspace.components.velocity;
import dspace.core.animationset;
import dspace.core.enemyspawner;
import dspace.core.game;
import dspace.core.spawner;
import dspace.core.statemachine;
import dspace.states.gamestate;

class PlayingState : GameState
{
    private static const(string) name = "playing";

    public static immutable(float) playerSpeed = 250.0f;

    private Entity       player;
    private Velocity     playerVel;
    private Dimensions   playerDim;
    private AnimationSet playerAnim;
    private PlayerState  playerState;
    private Sprite       healthbar;
    private Text         scoreText;
    private Spawner[]    spawners;

    this(Game pGame)
    {
        super(pGame);
        player = game.getPlayer();
        playerVel = player.getComponent!Velocity;
        playerDim = player.getComponent!Dimensions;
        playerAnim = cast(AnimationSet)player.getComponent!(Renderer).target;
        playerState = player.getComponent!PlayerState;

        auto resourceMgr = Game.getResourceMgr();
        healthbar = resourceMgr.getSprite("images/healthbar.png");
        auto font = resourceMgr.getFont("fonts/slkscr.ttf");
        scoreText = new Text("Score: 0", font, 13);
        scoreText.position = Vector2f(2, 10);

        auto spawnArea = FloatRect(0.0f, 0.0f, cast(float)game.screenMode.width, 0.0f);
        // Drone Spawner
        spawners ~= new EnemySpawner(game, spawnArea, 4.0f, new EnemyDetails(
            "drone",           // Type Name
            Vector2f(17, 20),  // Size
            "anim/drone.anim", // Animation
            150.0f,            // Speed
            1.0f               // Max Health
        ));
        // Seraph Spawner
        spawners ~= new EnemySpawner(game, spawnArea, 8.0f, new EnemyDetails(
            "seraph",           // Type Name
            Vector2f(17, 20),   // Size
            "anim/seraph.anim", // Animation
            100.0f,             // Speed
            2.0f                // Max Health
        ));
    }

    override const(string) getName() const
    {
        return name;
    }

    override bool onEnter(State previousState)
    {
        // Reset/enable player
        playerState.health = playerState.maxHealth;
        player.enable();

        // Reset spawners
        spawners[0].setInterval(4.0f);
        spawners[1].setInterval(8.0f);

        // Start background scrolling
        game.startScrolling();

        return super.onEnter(previousState);
    }

    override protected void renderUI(RenderWindow window)
    {
        auto playerState = player.getComponent!PlayerState;
        healthbar.textureRect = IntRect(0, 0, 8 * cast(int)playerState.health, 8);
        window.draw(healthbar);
        scoreText.setString(to!dstring(format("Score: %s", game.score)));
        window.draw(scoreText);
    }

    override protected void keyPressed(Keyboard.Key code)
    {
        switch (code) {
            case Keyboard.Key.Space:
                float x = playerDim.position.x + (playerDim.size.x / 2) - 2.0f;
                float y = playerDim.position.y - 9.0f;
                game.spawnBullet(Vector2f(x, y), CardinalDirection.UP);
                break;

            default:
                break;
        }
    }

    override protected void update(float delta)
    {
        if (playerState.health <= 0) {
            parent.transitionTo("gameover");
        }

        if (Keyboard.isKeyPressed(Keyboard.Key.Left)) {
            playerVel.velocity.x = -playerSpeed;
            playerAnim.setAnimation("bank-left");
        } else if (Keyboard.isKeyPressed(Keyboard.Key.Right)) {
            playerVel.velocity.x = playerSpeed;
            playerAnim.setAnimation("bank-right");
        } else {
            playerVel.velocity.x = 0;
            playerAnim.setAnimation("idle");
        }

        foreach (spawner; spawners) {
            spawner.tick(delta);
            spawner.setInterval(spawner.getInterval() - (delta / 10));
        }
    }
}