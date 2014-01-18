module entity;

import dsfml.graphics;

interface Entity {
    void Update(int ticks);
    void Draw(ref RenderWindow window);
    bool CheckCollision(IntRect rect);
}