module dspace.resources;

import core.memory;
import std.stdio;
import std.file;
import std.json;

import dsfml.graphics;
import dsfml.audio;


class Resource(T)
{
    T    data;
    uint age;

    this(T d)
    {
        data = d;
        age = 0;
    }
}

alias Resource!(Sprite) SpriteResource;
alias Resource!(Font)   FontResource;
alias Resource!(Sound)  SoundResource;

// Cache collection metafunction
void collectGroup(T, alias G)(uint ticks, uint maxAge)
{
    foreach (string name, T res; G) {
        if (name in G) {
            res.age += ticks;
            if (res.age >= maxAge) {
                writeln("Cleaning up " ~ name);
                G.remove(name);
            }
        }
    }
}

class ResourceManager
{

    // Maximum cache item age in milliseconds (1 minute)
    private static immutable(uint) maxAge = 60000;

    SpriteResource[string]    spriteCache;
    FontResource[string]      fontCache;
    SoundResource[string]     soundCache;

    private const(string) mergePath(const(string) name)
    {
        return "content/" ~ name;
    }


    public void collect(float delta)
    {
        uint ticks = cast(uint)(delta * 1000);
        collectGroup!(SpriteResource, spriteCache)(ticks, maxAge);
        collectGroup!(FontResource, fontCache)(ticks, maxAge);
        collectGroup!(SoundResource, soundCache)(ticks, maxAge);
    }


    public Sprite getSprite(const(string) name)
    {
        if (name in spriteCache) {
            auto res = spriteCache[name];
            res.age = 0;
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


    public Font getFont(const(string) name)
    {
        if (name in fontCache) {
            auto res = fontCache[name];
            res.age = 0;
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


    public Sound getSound(const(string) name)
    {
        if (name in soundCache) {
            auto res = soundCache[name];
            res.age = 0;
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


    public JSONValue getJSON(const(string) name)
    {
        return parseJSON(readText(mergePath(name)));
    }

}