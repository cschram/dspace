module dspace.statemachine;

import std.stdio;

class State
{
    StateMachine parent;

    const(string) getName()
    {
        return "Unknown State";
    }

    const(string)[] getTransitions()
    {
        return [];
    }

    bool transition(State nextState)
    {
        foreach (t; getTransitions())
        {
            if (t == nextState.getName())
            {
                return onExit(nextState);
            }
        }
        return false;
    }

    bool onEnter(State previousState)
    {
        return true;
    }

    bool onExit(State nextState)
    {
        return true;
    }

    bool update()
    {
        return true;
    }
}

class StateMachine
{
    private State[string] states;
    private State         currentState;

    void addState(State state)
    {
        auto name = state.getName();
        writeln("Registered state " ~ name);
        state.parent = this;
        states[name] = state;
    }

    State getCurrentState()
    {
        return currentState;
    }

    string getCurrentStateName()
    {
        return currentState.getName();
    }

    bool transitionTo(string name)
    {
        auto state = states.get(name, null);
        if (state !is null) {
            if (currentState && (!currentState.transition(state) || !state.onEnter(currentState))) {
                return false;
            }
            writeln("Transitioning to " ~ state.getName());
            currentState = state;
            return true;
        }
        return false;
    }

    bool update()
    {
        if (currentState) {
            return currentState.update();
        }
        return false;
    }
}