module dspace.states.game.playing;

import std.stdio;
import std.conv;
import std.string;

import artemisd.all;
import dsfml.graphics;

import dspace.components.playerstate;
import dspace.components.renderer;
import dspace.components.velocity;
import dspace.core.animationset;
import dspace.core.game;
import dspace.core.statemachine;
import dspace.states.gamestate;

class PlayingState : GameState
{
    private static const(string) name = "playing";

    public static immutable(float) playerSpeed = 250;

    private Entity       player;
    private Velocity     playerVel;
    private AnimationSet playerAnim;
    private PlayerState  playerState;
    private Sprite       healthbar;
    private Text         scoreText;

    this(Game pGame)
    {
        super(pGame);
        player = game.getPlayer();
        playerVel = player.getComponent!Velocity;
        playerAnim = cast(AnimationSet)player.getComponent!(Renderer).target;
        playerState = player.getComponent!PlayerState;

        auto resourceMgr = Game.getResourceMgr();
        healthbar = resourceMgr.getSprite("images/healthbar.png");
        auto font = resourceMgr.getFont("fonts/slkscr.ttf");
        scoreText = new Text("Score: 0", font, 13);
        scoreText.position = Vector2f(2, 10);
    }

    override const(string) getName() const
    {
        return name;
    }

    override bool onEnter(State previousState)
    {
        playerState.health = playerState.maxHealth;
        player.enable();
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
    }
}