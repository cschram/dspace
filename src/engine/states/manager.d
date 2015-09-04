module engine.states.manager;

debug import std.stdio;

import engine.states.state;

class StateManager
{
    private State[string] states;
    private string            currentState;

    void addState(string name, State state)
    {
        if (name in states) {
            throw new Exception("State \"" ~ name ~ "\" already exists.");
        }
        states[name] = state;
        if (currentState == "") {
            currentState = name;
        }
    }

    bool setState(string name)
    {
        if (name in states) {
            auto prev = states[currentState];
            auto next = states[name];
            if (prev.exit(name) && next.enter(currentState)) {
                currentState = name;
                return true;
            } else {
                debug writeln("Failed to transition to state \"" ~ name ~ "\".");
            }
        }
        return false;
    }

    State getState()
    {
        return states[currentState];
    }
}