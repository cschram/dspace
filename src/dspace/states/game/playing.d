module dspace.states.game.playing;

import std.conv;
import std.string;
import dsfml.graphics;
import dspace.game;
import dspace.core.statemachine;
import dspace.states.gamestate;

class PlayingState : GameState
{
    private static const(string) name = "playing";

    public static immutable(float) playerSpeed = 250;

    private Sprite healthbar;
    private Text   scoreText;

    this()
    {
        auto resourceMgr = Game.getInstance().getResourceMgr();
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
        auto game = Game.getInstance();
        game.startScrolling();
        return super.onEnter(previousState);
    }

    override void handleInput()
    {
        super.handleInput();

        auto player = Game.getInstance().getPlayer();
        auto vel = Vector2f(0, 0);

        if (Keyboard.isKeyPressed(Keyboard.Key.Left)) {
            vel.x = -playerSpeed;
        } else if (Keyboard.isKeyPressed(Keyboard.Key.Right)) {
            vel.x = playerSpeed;
        }

        player.setVelocity(vel);
    }

    override void render(RenderWindow window)
    {
        auto game = Game.getInstance();
        auto entities = game.getEntities();
        auto player = game.getPlayer();
        auto score = game.getScore();

        // Draw entities
        foreach (e; entities) {
            if (e.isDrawable()) {
                window.draw(e.getSprite());
            }
        }

        // UI
        healthbar.textureRect = IntRect(0, 0, 8 * player.getHealth(), 8);
        window.draw(healthbar);
        scoreText.setString(to!dstring(format("Score: %s", score)));
        window.draw(scoreText);
    }

    override bool update(float delta)
    {
        auto game = Game.getInstance();
        auto entities = game.getEntities();

        handleInput();

        foreach (e; entities) {
            e.update(delta);
        }

        auto player = game.getPlayer();
        if (player.getHealth() <= 0) {
            parent.transitionTo("gameover");
        }

        return true;
    }
}