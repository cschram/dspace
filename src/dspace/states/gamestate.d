module dspace.states.gamestate;

import dsfml.window;
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

    void render() {}

    override bool update()
    {
        handleInput();
        render();
        return true;
    }
}