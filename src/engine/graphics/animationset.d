module engine.graphics.animationset;

import std.json;

import dsfml.graphics;

import engine.resourcemgr;
import engine.graphics.animation;

class AnimationSet
{
    private Sprite            sprite;
    private Vector2i          size;
    private Animation[string] animations;
    private string            currentAnimName;
    private Animation         currentAnim;

    static AnimationSet loadFromFile(string name)
    {
        auto json = ResourceManager.getJSON(name);
        auto sprite = ResourceManager.getSprite(json.object["sprite"].str);
        auto size = Vector2i(cast(int)json.object["size"][0].integer, cast(int)json.object["size"][1].integer);

        Animation[string] animations;
        auto animList = json.object["animations"].object;
        foreach (string animName, JSONValue animJSON; animList) {
            AnimationFrame[] frames;
            auto framesJSON = animJSON.object["frames"].array;
            for (size_t i = 0; i < framesJSON.length; i++) {
                frames ~= AnimationFrame(
                    cast(uint)framesJSON[i].object["spriteIndex"].integer,
                    framesJSON[i].object["duration"].floating
                );
            }

            if (animJSON.object["loop"].type == JSON_TYPE.TRUE) {
                animations[animName] = new Animation(sprite, frames, size, true);
            } else {
                animations[animName] = new Animation(sprite, frames, size, false);
            }
        }

        return new AnimationSet(sprite, size, animations);
    }

    this(Sprite pSprite, Vector2i pSize, Animation[string] pAnim)
    {
        sprite = pSprite;
        size = pSize;
        animations = pAnim;
        setAnimation(animations.keys[0]);
    }

    Sprite getSprite()
    {
        return sprite;
    }

    bool tick(float delta)
    {
        return currentAnim.tick(delta);
    }

    void setAnimation(string name, bool restart=false)
    {
        if (name == currentAnimName && restart) {
            currentAnim.restart();
        } else {
            currentAnimName = name;
            currentAnim = animations[name];
            currentAnim.restart();
        }
    }
}