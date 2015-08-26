module dspace.states.gamestate;

import std.stdio;

import dsfml.graphics;
import dspace.core.game;
import dspace.core.statemachine;

class GameState : State
{

    private   bool         active;
    protected StateMachine parent;
    protected Game         game;

    this(Game pGame)
    {
        game = pGame;
        game.connect(&this.handleEvent);
    }

    private void handleEvent(GameEvent e)
    {
        if (!active) return;

        switch (e.type) {
            case GameEvent.EventType.STAGE_UPDATE:
                switch (e.loopStage) {
                    case GameEvent.LoopStage.UPDATE:
                        update(e.delta);
                        break;

                    case GameEvent.LoopStage.RENDER_BACKGROUND:
                        renderBackground(e.renderWindow);
                        break;

                    case GameEvent.LoopStage.RENDER_UI:
                        renderUI(e.renderWindow);
                        break;

                    default: break;
                }
                break;

            case GameEvent.EventType.KEY_PRESSED:
                keyPressed(e.keyCode);
                break;

            default: break;
        }
    }

    protected void update(float delta) {}
    protected void renderBackground(RenderWindow window) {}
    protected void renderUI(RenderWindow window) {}
    protected void keyPressed(Keyboard.Key code) {}

    const(string) getName() const
    {
        return "Unknown Game State";
    }

    void setParent(StateMachine p)
    {
        parent = p;
    }

    bool onEnter(State previousState)
    {
        active = true;
        return true;
    }

    bool onExit(State nextState)
    {
        active = false;
        return true;
    }
}