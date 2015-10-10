module engine.graphics.animation;

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
        auto json     = ResourceManager.getJSON(name);
        auto sprite   = ResourceManager.getSprite(json.object["sprite"].str);
        auto size     = Vector2i(cast(int)json.object["size"][0].integer, cast(int)json.object["size"][1].integer);
        Sound bgAudio = null;

        AnimationFrame[] frames;
        auto framesJSON = json.object["frames"].array;
        for (size_t i = 0; i < framesJSON.length; i++) {
            frames ~= AnimationFrame(
                cast(uint)framesJSON[i].object["spriteIndex"].integer,
                framesJSON[i].object["duration"].floating
            );
        }

        if (!json.object["audio"].isNull()) {
            bgAudio = ResourceManager.getSound(json.object["audio"].object["sound"].str);
            if (json.object["audio"].object["loop"].type == JSON_TYPE.TRUE) {
                bgAudio.isLooping = true;
            }
        }

        if (json.object["loop"].type == JSON_TYPE.TRUE) {
            return new Animation(sprite, frames, size, true, bgAudio);
        } else {
            return new Animation(sprite, frames, size, false, bgAudio);
        }
    }

    this(Sprite pSprite, AnimationFrame[] pFrames, Vector2i pSize, bool pLoop, Sound pAudio=null)
    {
        sprite      = pSprite;
        frames      = pFrames;
        size        = pSize;
        loop        = pLoop;
        bgAudio     = pAudio;
        frame       = frames[0];
        spriteSheet = new SpriteSheet(sprite, size, frame.spriteIndex);
        timeDelta   = 0;

        if (bgAudio !is null) {
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