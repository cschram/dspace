module engine.statemgr;

import dsfml.graphics;

import engine.game;

interface GameState
{
    bool enter(string prev);
    bool exit(string next);

    void handleInput(Event evt);
    void update(float delta);
}

class StateManager
{
    private GameState[string] states;
    private string            currentState;

    void addState(string name, GameState state)
    {
        states[name] = state;
        if (currentState == "") {
            currentState = name;
        }
    }

    void setState(string name)
    {
        if (name in states) {
            auto prev = states[currentState];
            auto next = states[name];
            if (prev.exit(name) && next.enter(currentState)) {
                currentState = name;
            }
        }
    }

    void getState()
    {
        return states[currentState];
    }
}