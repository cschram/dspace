module dspace.states.gamestate;

import dsfml.graphics;
import dspace.game;
import dspace.statemachine;

class GameState : State
{

    void keyPressed(Keyboard.Key code) {}

    void handleInput()
    {
        auto game = Game.getInstance();
        Event e;
        while (game.pollEvent(e))
        {
            switch (e.type)
            {
                case e.EventType.KeyPressed:
                    keyPressed(e.key.code);
                    break;

                default: break;
            }
        }
    }

    void render(RenderWindow window) {}

    override bool update(float delta)
    {
        handleInput();
        return true;
    }
}