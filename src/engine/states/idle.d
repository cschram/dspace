module engine.states.idle;

import dsfml.graphics;

import engine.states.state;

class IdleState : State
{
    RenderWindow window;

    this(RenderWindow win)
    {
        window = win;
    }

    bool enter(string prev)
    {
        return true;
    }

    bool exit(string next)
    {
        return true;
    }

    void handleInput(Event evt)
    {

    }

    void update(float delta)
    {
        window.clear();
        window.display();
    }
}