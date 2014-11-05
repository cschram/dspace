module dspace.states.game.playing;

import std.conv;
import std.string;

import artemisd.all;
import dsfml.graphics;

import dspace.core.game;
import dspace.core.statemachine;
import dspace.states.gamestate;
import dspace.components.velocity;

class PlayingState : GameState
{
    private static const(string) name = "playing";

    public static immutable(float) playerSpeed = 250;

    private Entity player;
    private Sprite healthbar;
    private Text   scoreText;

    this(Game pGame)
    {
        super(pGame);
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
        player = game.getPlayer();
        player.addToWorld();
        game.startScrolling();
        return super.onEnter(previousState);
    }

    override bool onExit(State nextState)
    {
        player.deleteFromWorld();
        return super.onExit(nextState);
    }

    override protected void renderUI(RenderWindow window)
    {
        //healthbar.textureRect = IntRect(0, 0, 8 * player.getHealth(), 8);
        healthbar.textureRect = IntRect(0, 0, 80, 8);
        window.draw(healthbar);
        scoreText.setString(to!dstring(format("Score: %s", game.score)));
        window.draw(scoreText);
    }

    override protected void update(float delta)
    {
        auto playerVel = player.getComponent!Velocity;

        //if (player.getHealth() <= 0) {
        //    parent.transitionTo("gameover");
        //}

        if (Keyboard.isKeyPressed(Keyboard.Key.Left)) {
            playerVel.velocity.x = -playerSpeed;
        } else if (Keyboard.isKeyPressed(Keyboard.Key.Right)) {
            playerVel.velocity.x = playerSpeed;
        } else {
            playerVel.velocity.x = 0;
        }
    }
}