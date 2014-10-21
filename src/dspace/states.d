module dspace.states;

import std.stdio;

class State
{
    string                name;
    string[]              transitions;
    void delegate()       update;
    bool delegate(string) transitionHandler;

    this(
        string name,
        string[] transitions,
        void delegate() update,
        bool delegate(string) transitionHandler)
    {
        this.name              = name;
        this.transitions       = transitions;
        this.update            = update;
        this.transitionHandler = transitionHandler;
    }

    bool transition(string name)
    {
        foreach (t; transitions)
        {
            if (t == name)
            {
                return transitionHandler(name);
            }
        }
        return false;
    }
}

class StateMachine
{

    private State[string] states;
    private State         currentState;

    void addState(State state)
    {
        if (states.keys.length == 0)
        {
            currentState = state;
        }
        states[state.name] = state;
    }

    State getCurrentState()
    {
        return currentState;
    }

    string getCurrentStateName()
    {
        return currentState.name;
    }

    bool transition(string name)
    {
        auto state = states.get(name, null);
        if (state !is null && currentState.transition(name))
        {
            currentState = state;
            return true;
        }
        return false;
    }

    void update() {
        currentState.update();
    }

}

unittest {
    auto fsm = new StateMachine();

    class TestData
    {
        int foo = 1;

        private void changeFoo()
        {
            foo = 2;
            writeln("set foo to 2");
        }

        void printFoo()
        {
            writeln(foo);
        }
    }
    auto data = new TestData();

    auto fooState = new State(
        "foo",
        ["bar"],
        &data.printFoo,
        delegate(string name)
        {
            if (data.foo == 1)
            {
                writeln("transition from foo to " ~ name);
                return true;
            }
            return false;
        }
    );

    auto barState = new State(
        "bar",
        ["foo"],
        &data.changeFoo,
        delegate(string name) {
            writeln("transition from bar to "  ~ name);
            return true;
        }
    );

    auto bazState = new State("baz", [], delegate() {}, delegate(string name) { return true; });

    fsm.addState(fooState);
    fsm.addState(barState);
    fsm.addState(bazState);

    fsm.update();
    assert(fsm.transition("bar") == true);
    fsm.update();
    assert(fsm.transition("baz") == false);
    assert(fsm.transition("foo") == true);
    fsm.update();
    assert(fsm.transition("baz") == false);
}