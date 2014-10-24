module dspace.animation;

import std.conv;
import std.json;
import dsfml.system;
import dsfml.graphics;
import dspace.game;
import dspace.spritesheet;

class Animation
{

    private ushort[]    frames;
    private Sprite      sprite;
    private SpriteSheet spriteSheet;
    private Vector2i    size;
    private bool        loop;
    private bool        finished;
    private ushort      ticks;
    private ushort      frame;

    public this(Sprite _sprite, JSONValue config)
    {
        sprite = _sprite;
        size = Vector2i(
            to!int(config.object["width"].integer),
            to!int(cast(int)config.object["height"].integer)
        );

        spriteSheet = new SpriteSheet(_sprite, size);

        auto loopval = config.object["loop"];
        if (loopval.type() == JSON_TYPE.TRUE) {
            loop = true;
        } else {
            loop = false;
        }

        auto _frames = config.object["frames"].array;
        frames.length = _frames.length;
        for (size_t i = 0; i < _frames.length; i++) {
            frames[i] = to!ushort(_frames[i].uinteger);
        }
    }

    public Sprite getSprite()
    {
        return sprite;
    }

    public bool tick(ushort numTicks)
    {
        ticks += numTicks;

        if (ticks > frames[frame]) {
            ticks = 0;
            frame++;

            if (frame >= frames.length) {
                frame = 0;
                if (!loop) {
                    finished = true;
                    return true;
                }
            }

            spriteSheet.setIndex(frame);
        }

        return false;
    }

    public bool isPlaying()
    {
        return !finished;
    }

    public void restart()
    {
        ticks = 0;
        frame = 0;
        finished = false;
    }

}