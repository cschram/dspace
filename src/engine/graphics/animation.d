module engine.graphics.animation;

debug import std.stdio;
import std.json;

import dsfml.audio;
import dsfml.graphics;

import engine.resourcemgr;
import engine.graphics.spritesheet;

struct AnimationFrame
{
    uint  spriteIndex;
    float duration;
}

class Animation : Drawable
{
    private string           name;
    private AnimationFrame[] frames;
    private Sprite           sprite;
    private SpriteSheet      spriteSheet;
    private Vector2i         size;
    private bool             loop;
    private Sound            bgAudio;
    private bool             finished;
    private float            timeDelta;
    private uint             frameIndex;
    private AnimationFrame   frame;

    static Animation loadFromFile(string name)
    {
        auto json     = ResourceManager.getJSON(name).object;
        auto sprite   = ResourceManager.getSprite(json["sprite"].str);
        auto size     = Vector2i(cast(int)json["size"][0].integer, cast(int)json["size"][1].integer);
        Sound bgAudio = null;

        AnimationFrame[] frames;
        auto framesJSON = json["frames"].array;
        for (size_t i = 0; i < framesJSON.length; i++) {
            frames ~= AnimationFrame(
                cast(uint)framesJSON[i].object["spriteIndex"].integer,
                framesJSON[i].object["duration"].floating
            );
        }

        if ("audio" in json) {
            bgAudio = ResourceManager.getSound(json["audio"].object["sound"].str);
            if (json["audio"].object["loop"].type == JSON_TYPE.TRUE) {
                bgAudio.isLooping = true;
            }
        }

        if (json["loop"].type == JSON_TYPE.TRUE) {
            return new Animation(name, sprite, frames, size, true, bgAudio);
        } else {
            return new Animation(name, sprite, frames, size, false, bgAudio);
        }
    }

    this(string pName, Sprite pSprite, AnimationFrame[] pFrames, Vector2i pSize, bool pLoop, Sound pAudio=null, bool playImmediately=true)
    {
        name        = pName;
        sprite      = pSprite;
        frames      = pFrames;
        size        = pSize;
        loop        = pLoop;
        bgAudio     = pAudio;
        frame       = frames[0];
        spriteSheet = new SpriteSheet(sprite, size, frame.spriteIndex);
        timeDelta   = 0;

        if (bgAudio !is null && playImmediately) {
            bgAudio.play();
        }
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
        timeDelta  = 0;
        frameIndex = 0;
        finished   = false;
        setFrame(0);

        if (bgAudio !is null) {
            bgAudio.play();
        }
    }

    bool update(float delta)
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

    override void draw(RenderTarget target, RenderStates renderStates)
    {
        sprite.draw(target, renderStates);
    }
}