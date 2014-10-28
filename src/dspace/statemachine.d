module dspace.statemachine;

import std.stdio;

class State
{
    StateMachine parent;

    const(string) getName() const
    {
        return "Unknown State";
    }

    bool onEnter(State previousState)
    {
        return true;
    }

    bool onExit(State nextState)
    {
        return true;
    }

    bool update(float delta)
    {
        return true;
    }
}

class StateMachine
{
    private State[const(string)] states;
    private State                currentState;

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

    const(string) getCurrentStateName() const
    {
        return currentState.getName();
    }

    bool transitionTo(const(string) name)
    {
        auto state = states.get(name, null);
        if (state !is null) {
            if (currentState && (!currentState.onExit(state) || !state.onEnter(currentState))) {
                return false;
            }
            writeln("Transitioning to " ~ state.getName());
            currentState = state;
            return true;
        }
        return false;
    }

    bool update(float delta)
    {
        if (currentState) {
            return currentState.update(delta);
        }
        return false;
    }
}