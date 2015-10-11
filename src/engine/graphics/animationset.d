module engine.graphics.animationset;

debug import std.stdio;
import std.json;

import dsfml.audio;
import dsfml.graphics;

import engine.resourcemgr;
import engine.graphics.animation;

class AnimationSet : Drawable
{
    private Sprite            sprite;
    private Vector2i          size;
    private Animation[string] animations;
    private string[string]    transitions;
    private string            current;

    static AnimationSet loadFromFile(string name)
    {
        auto json   = ResourceManager.getJSON(name).object;
        auto sprite = ResourceManager.getSprite(json["sprite"].str);
        auto size   = Vector2i(cast(int)json["size"][0].integer, cast(int)json["size"][1].integer);
        string defaultAnim = json["default"].str;
        string[string] transitions;

        Animation[string] animations;
        auto animList = json["animations"].object;
        foreach (string animName, JSONValue animJSON; animList) {
            AnimationFrame[] frames;
            Sound bgAudio = null;
            auto framesJSON = animJSON.object["frames"].array;
            for (size_t i = 0; i < framesJSON.length; i++) {
                frames ~= AnimationFrame(
                    cast(uint)framesJSON[i].object["spriteIndex"].integer,
                    framesJSON[i].object["duration"].floating
                );
            }

            if ("transitionTo" in animJSON.object) {
                transitions[animName] = animJSON.object["transitionTo"].str;
            }

            if ("audio" in animJSON.object) {
                bgAudio = ResourceManager.getSound(animJSON.object["audio"].object["sound"].str);
                if (animJSON.object["audio"].object["loop"].type == JSON_TYPE.TRUE) {
                    bgAudio.isLooping = true;
                }
            }

            if (animJSON.object["loop"].type == JSON_TYPE.TRUE) {
                animations[animName] = new Animation(name, sprite, frames, size, true, bgAudio, false);
            } else {
                animations[animName] = new Animation(name, sprite, frames, size, false, bgAudio, false);
            }
        }

        return new AnimationSet(sprite, size, animations, defaultAnim, transitions);
    }

    this(Sprite pSprite, Vector2i pSize, Animation[string] pAnim, string defaultAnim, string[string] pTransitions)
    {
        sprite      = pSprite;
        size        = pSize;
        animations  = pAnim;
        transitions = pTransitions;
        current     = defaultAnim;
        writeln(current);
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

    bool update(float delta)
    {
        auto playing = animations[current].update(delta);
        if (!playing && current in transitions) {
            setAnimation(transitions[current]);
            return true;
        }
        return playing;
    }

    override void draw(RenderTarget target, RenderStates renderStates)
    {
        sprite.draw(target, renderStates);
    }
}