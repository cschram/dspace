module engine.states.manager;

import engine.states.state;

class StateManager
{
    private State[string] states;
    private string            currentState;

    void addState(string name, State state)
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

    State getState()
    {
        return states[currentState];
    }
}