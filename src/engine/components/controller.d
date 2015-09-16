module engine.components.controller;

import engine.controller;

class EntityController
{
    Controller controller;

    this(Controller pController)
    {
        controller = pController;
    }

    invariant
    {
        assert(controller !is null);
    }
}