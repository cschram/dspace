module dspace.core.resourcemgr;

import core.memory;
import std.stdio;
import std.file;
import std.json;

import dsfml.graphics;
import dsfml.audio;

import dspace.core.animation;
import dspace.core.animationset;


class Resource(T)
{
    T     data;
    float age;

    this(T d)
    {
        data = d;
        age = 0;
    }
}

alias Resource!(Sprite)       SpriteResource;
alias Resource!(Font)         FontResource;
alias Resource!(Sound)        SoundResource;
alias Resource!(Animation)    AnimationResource;
alias Resource!(AnimationSet) AnimationSetResource;

// Cache collection metafunction
void collectGroup(T, alias G)(float delta, float maxAge)
{
    foreach (string name, T res; G) {
        if (name in G) {
            res.age += delta;
            if (res.age >= maxAge) {
                writeln("Cleaning up " ~ name);
                G.remove(name);
            }
        }
    }
}

class ResourceManager
{

    // Maximum cache item age in seconds
    private static immutable(float) maxAge = 60.0f;

    SpriteResource[string]       spriteCache;
    FontResource[string]         fontCache;
    SoundResource[string]        soundCache;
    AnimationResource[string]    animCache;
    AnimationSetResource[string] animSetCache;

    private const(string) mergePath(const(string) name)
    {
        return "content/" ~ name;
    }

    void collect(float delta)
    {
        collectGroup!(SpriteResource, spriteCache)(delta, maxAge);
        collectGroup!(FontResource, fontCache)(delta, maxAge);
        collectGroup!(SoundResource, soundCache)(delta, maxAge);
        collectGroup!(AnimationResource, animCache)(delta, maxAge);
        collectGroup!(AnimationSetResource, animSetCache)(delta, maxAge);
    }

    JSONValue getJSON(const(string) name)
    {
        return parseJSON(readText(mergePath(name)));
    }

    Sprite getSprite(const(string) name)
    {
        if (name in spriteCache) {
            auto res = spriteCache[name];
            res.age = 0.0f;
            return res.data;
        } else {
            auto tex = new Texture();
            if (!tex.loadFromFile(mergePath(name))) {
                throw new Exception("Could not load Sprite '" ~ name ~ "'.");
            }
            auto sprite = new Sprite(tex);
            spriteCache[name] = new SpriteResource(sprite);
            return sprite;
        }
    }

    Font getFont(const(string) name)
    {
        if (name in fontCache) {
            auto res = fontCache[name];
            res.age = 0.0f;
            return res.data;
        } else {
            auto font = new Font();
            if (!font.loadFromFile(mergePath(name))) {
                throw new Exception("Could not load Font '" ~ name ~ "'.");
            }
            fontCache[name] = new FontResource(font);
            return font;
        }
    }

    Sound getSound(const(string) name)
    {
        if (name in soundCache) {
            auto res = soundCache[name];
            res.age = 0.0f;
            return res.data;
        } else {
            auto buf = new SoundBuffer();
            if (!buf.loadFromFile(mergePath(name))) {
                throw new Exception("Could not load Sound '" ~ name ~ "'.");
            }
            auto sound = new Sound(buf);
            soundCache[name] = new SoundResource(sound);
            return sound;
        }
    }

    Animation getAnimation(const(string) name)
    {
        if (name in animCache) {
            auto res = animCache[name];
            res.age = 0.0f;
            return res.data;
        } else {
            auto anim = Animation.loadFromFile(name);
            animCache[name] = new AnimationResource(anim);
            return anim;
        }
    }

    AnimationSet getAnimationSet(const(string) name)
    {
        if (name in animSetCache) {
            auto res = animSetCache[name];
            res.age = 0.0f;
            return res.data;
        } else {
            auto animSet = AnimationSet.loadFromFile(name);
            animSetCache[name] = new AnimationSetResource(animSet);
            return animSet;
        }
    }

}