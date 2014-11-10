module dspace.core.animation;

import std.stdio;
import std.conv;
import std.json;

import dsfml.system;
import dsfml.graphics;

import dspace.core.game;
import dspace.core.renderable;
import dspace.core.spritesheet;

struct AnimationFrame
{
    uint  spriteIndex;
    float duration;
}

class Animation : Renderable
{

    private AnimationFrame[] frames;
    private Sprite           sprite;
    private SpriteSheet      spriteSheet;
    private Vector2i         size;
    private bool             loop;
    private bool             finished;
    private float            timeDelta;
    private uint             frameIndex;
    private AnimationFrame   frame;

    static Animation loadFromFile(const(string) name)
    {
        auto resourceMgr = Game.getResourceMgr();
        auto json = resourceMgr.getJSON(name);

        auto sprite = resourceMgr.getSprite(json.object["sprite"].str);
        auto size = Vector2i(cast(int)json.object["size"][0].integer, cast(int)json.object["size"][1].integer);

        AnimationFrame[] frames;
        auto framesJSON = json.object["frames"].array;
        for (size_t i = 0; i < framesJSON.length; i++) {
            frames ~= AnimationFrame(
                cast(uint)framesJSON[i].object["spriteIndex"].integer,
                framesJSON[i].object["duration"].floating
            );
        }

        if (json.object["loop"].type == JSON_TYPE.TRUE) {
            return new Animation(sprite, frames, size, true);
        } else {
            return new Animation(sprite, frames, size, false);
        }
    }

    this(Sprite pSprite, AnimationFrame[] pFrames, Vector2i pSize, bool pLoop)
    {
        sprite = pSprite;
        frames = pFrames;
        size = pSize;
        loop = pLoop;
        frame = frames[0];
        spriteSheet = new SpriteSheet(sprite, size, frame.spriteIndex);
        timeDelta = 0.0f;
    }

    private void setFrame(uint index)
    {
        frame = frames[index];
        spriteSheet.setIndex(frame.spriteIndex);
    }

    bool isPlaying()
    {
        return !finished;
    }

    void restart()
    {
        timeDelta = 0;
        frameIndex = 0;
        finished = false;
        setFrame(0);
    }

    Sprite getSprite()
    {
        return sprite;
    }

    bool tick(float delta)
    {
        if (finished) return false;

        timeDelta += delta;

        if (timeDelta > frame.duration) {
            timeDelta = 0;
            frameIndex++;

            if (frameIndex >= frames.length) {
                frameIndex = 0;
                if (!loop) {
                    finished = true;
                    return false;
                }
            }

            setFrame(frameIndex);
        }

        return true;
    }
}