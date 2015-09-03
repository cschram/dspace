module engine.states.state;

import dsfml.window;

interface State
{
    bool enter(string prev);
    bool exit(string next);

    void handleInput(Event evt);
    void update(float delta);
}