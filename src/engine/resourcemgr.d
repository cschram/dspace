module engine.resourcemgr;

import std.file;
import std.json;

import dsfml.graphics;
import dsfml.audio;

import engine.graphics.animation;
import engine.graphics.animationset;
import engine.util.cache;

final abstract class ResourceManager
{
    private static immutable(float) maxAge = 60.0f;

    private __gshared Cache!Sprite       spriteCache;
    private __gshared Cache!Font         fontCache;
    private __gshared Cache!Sound        soundCache;
    private __gshared Cache!Animation    animCache;
    private __gshared Cache!AnimationSet animSetCache;

    static this()
    {
        spriteCache  = new Cache!Sprite(maxAge);
        fontCache    = new Cache!Font(maxAge);
        soundCache   = new Cache!Sound(maxAge);
        animCache    = new Cache!Animation(maxAge);
        animSetCache = new Cache!AnimationSet(maxAge);
    }

    private static string mergePath(string name)
    {
        return "content/" ~ name;
    }

    static void collect(float delta)
    {
        synchronized {
            spriteCache.collect(delta);
            fontCache.collect(delta);
            soundCache.collect(delta);
            animCache.collect(delta);
            animSetCache.collect(delta);
        }
    }

    static void flush()
    {
        synchronized {
            spriteCache.empty();
            fontCache.empty();
            soundCache.empty();
            animCache.empty();
            animSetCache.empty();
        }
    }

    static JSONValue getJSON(string name)
    {
        return parseJSON(readText(mergePath(name)));
    }

    static Sprite getSprite(string name)
    {
        synchronized {
            auto sprite = spriteCache.get(name);
            if (sprite is null) {
                auto tex = new Texture();
                if (!tex.loadFromFile(mergePath(name))) {
                    throw new Exception("Could not load Sprite '" ~ name ~ "'.");
                }
                sprite = new Sprite(tex);
                spriteCache.set(name, sprite);
            }
            return sprite;
        }
    }

    static Font getFont(string name)
    {
        synchronized {
            auto font = fontCache.get(name);
            if (font is null) {
                font = new Font();
                if (!font.loadFromFile(mergePath(name))) {
                    throw new Exception("Could not load Font '" ~ name ~ "'.");
                }
                fontCache.set(name, font);
            }
            return font;
        }
    }

    static Sound getSound(string name)
    {
        synchronized {
            auto sound = soundCache.get(name);
            if (sound is null) {
                auto buf = new SoundBuffer();
                if (!buf.loadFromFile(mergePath(name))) {
                    throw new Exception("Could not load Sound '" ~ name ~ "'.");
                }
                sound = new Sound(buf);
                soundCache.set(name, sound);
            }
            return sound;
        }
    }

    static Animation getAnimation(string name)
    {
        synchronized {
            auto anim = animCache.get(name);
            if (anim is null) {
                anim = Animation.loadFromFile(mergePath(name));
                animCache.set(name, anim);
            }
            return anim;
        }
    }

    static AnimationSet getAnimationSet(string name)
    {
        synchronized {
            auto animSet = animSetCache.get(name);
            if (animSet is null) {
                animSet = AnimationSet.loadFromFile(name);
                animSetCache.set(name, animSet);
            }
            return animSet;
        }
    }
}