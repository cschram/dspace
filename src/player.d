module player;

import dsfml.graphics;
import dsfml.audio;

import game;
import entity;
import ship;

class Player : Entity, Ship {
private:

    Sprite   sprite;
    Vector2f position;
    Vector2f velocity;
    int      health;

public:

    static Vector2i size = Vector2i(55, 61);

    this() {
        auto game = Game.GetInstance();

        sprite   = game.Resources().getSprite("content/images/ship-idle.png");
        position = Vector2f(372, 539);
        health   = 10;
    }

    void Update(int ticks) {
        position += velocity * ticks;
        sprite.position = position;
    }

    void Draw(ref RenderWindow window) {
        window.draw(sprite);
    }

    bool CheckCollision(IntRect target) {
        auto rect = IntRect(cast(Vector2i)position, size);
        return rect.intersects(target);
    }

    bool Hit(int damage) {
        health -= damage;
        return IsDestroyed();
    }

    bool IsDestroyed() {
        return (health < 1);
    }

    void KeyPressed(Keyboard.Key code) {
        switch (code) {
            default:
                break;

            case Keyboard.Key.Space:
                break;
        }
    }

}