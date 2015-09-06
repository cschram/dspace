module engine.graphics.animationset;

import std.json;

import dsfml.graphics;

import engine.resourcemgr;
import engine.graphics.animation;

class AnimationSet : Drawable
{
    private Sprite            sprite;
    private Vector2i          size;
    private Animation[string] animations;
    private string            current;

    static AnimationSet loadFromFile(string name)
    {
        auto json   = ResourceManager.getJSON(name);
        auto sprite = ResourceManager.getSprite(json.object["sprite"].str);
        auto size   = Vector2i(cast(int)json.object["size"][0].integer, cast(int)json.object["size"][1].integer);

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
        sprite     = pSprite;
        size       = pSize;
        animations = pAnim;
        current    = animations.keys[0];
        animations[current].restart();
    }

    void setAnimation(string name, bool restart=false)
    {
        if (name != current) {
            current = name;
            animations[current].restart();
        } else if (restart) {
            animations[current].restart();
        }
    }

    bool isPlaying()
    {
        return animations[current].isPlaying();
    }

    bool tick(float delta)
    {
        return animations[current].tick(delta);
    }

    override void draw(RenderTarget target, RenderStates renderStates)
    {
        sprite.draw(target, renderStates);
    }
}