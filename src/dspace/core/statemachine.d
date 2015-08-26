module dspace.core.statemachine;

import std.stdio;

interface State
{
    const(string) getName() const;

    void setParent(StateMachine parent);

    bool onEnter(State previousState);

    bool onExit(State nextState);

    void update(float delta);
}

class StateMachine
{
    private State[const(string)] states;
    private State                currentState;

    void addState(State state)
    {
        auto name = state.getName();
        writeln("Registered state " ~ name);
        state.setParent(this);
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
            if ((currentState && !currentState.onExit(state)) || !state.onEnter(currentState)) {
                return false;
            }
            writeln("Transitioning to " ~ state.getName());
            currentState = state;
            return true;
        }
        return false;
    }

    void update(float delta)
    {
        if (currentState) {
            currentState.update(delta);
        }
    }
}