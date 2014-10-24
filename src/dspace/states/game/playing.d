module dspace.states.game.playing;

import std.conv;
import std.string;
import artemisd.all;
import dsfml.graphics;
import dspace.game;
import dspace.statemachine;
import dspace.components.dimensions;
import dspace.components.entitysprite;
import dspace.components.entitystate;
import dspace.components.velocity;
import dspace.states.gamestate;

class PlayingState : GameState
{
    private static const(string)   name        = "playing";
    private static const(string)[] transitions = [ "gameover" ];

    public static immutable(float)     scrollSpeed = 0.5;
    public static immutable(float)     playerSpeed = 250;

    private Sprite background;
    private Sprite healthbar;
    private Text   scoreText;
    private float  backgroundPosition = 1000;
    private bool   backgroundMoving   = true;

    this()
    {
        auto resources = Game.getInstance().getResources();

        // Images
        background = resources.getSprite("images/background.png");
        healthbar = resources.getSprite("images/healthbar.png");
        background.textureRect = IntRect(0, cast(int)backgroundPosition, 400, 600);

        // Text
        auto font = resources.getFont("fonts/slkscr.ttf");
        scoreText = new Text("Score: 0", font, 13);
        scoreText.position = Vector2f(2, 10);
    }

    override const(string) getName()
    {
        return name;
    }

    override const(string)[] getTransitions()
    {
        return transitions;
    }

    override bool onEnter(State previousState)
    {
        auto game = Game.getInstance();
        auto groupManager = game.getWorld().getManager!GroupManager;
        auto player = game.getPlayer();
        groupManager.add(player, "drawable");
        return true;
    }

    override bool onExit(State nextState)
    {
        auto game = Game.getInstance();
        auto groupManager = game.getWorld().getManager!GroupManager;
        auto player = game.getPlayer();
        groupManager.getEntities("drawable").clear();
        return true;
    }

    override void handleInput()
    {
        super.handleInput();

        auto player = Game.getInstance().getPlayer();
        auto playerVel = player.getComponent!Velocity;

        if (Keyboard.isKeyPressed(Keyboard.Key.Left)) {
            playerVel.vel.x = -playerSpeed;
        } else if (Keyboard.isKeyPressed(Keyboard.Key.Right)) {
            playerVel.vel.x = playerSpeed;
        } else {
            playerVel.vel.x = 0;
        }
    }

    override void render()
    {
        auto game = Game.getInstance();
        auto window = game.getWindow();
        auto groupManager = game.getWorld().getManager!GroupManager;
        auto drawable = groupManager.getEntities("drawable");
        auto player = game.getPlayer();
        auto playerState = player.getComponent!EntityState;
        auto score = game.getScore();

        window.clear();
        window.draw(background);

        // Draw entities
        for (size_t i = 0; i < drawable.size(); i++) {
            Entity e = drawable.get(i);
            auto sprite = e.getComponent!EntitySprite;
            auto dim    = e.getComponent!Dimensions;
            if (sprite.prepareRender(dim.position)) {
                window.draw(sprite.getSprite());
            }
        }

        // UI
        healthbar.textureRect = IntRect(0, 0, 8 * playerState.health, 8);
        window.draw(healthbar);
        scoreText.setString(to!dstring(format("Score: %s", score)));
        window.draw(scoreText);

        window.display();
    }

    override bool update()
    {
        auto game  = Game.getInstance();
        auto world = game.getWorld();

        if (backgroundMoving) {
            backgroundPosition -= scrollSpeed;
            // Avoiding creating a new IntRect every loop iteration
            auto updatedRect = background.textureRect;
            updatedRect.top = cast(int)backgroundPosition;
            background.textureRect = updatedRect;
            backgroundMoving = (backgroundPosition > 0);
        }

        handleInput();

        world.setDelta(1/60.0f);
        world.process();

        auto player = game.getPlayer();
        auto playerState = player.getComponent!EntityState;
        if (playerState.health <= 0) {
            parent.transitionTo("gameover");
        }

        render();

        return true;
    }
}