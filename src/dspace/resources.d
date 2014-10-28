module dspace.resources;

import std.container;
import std.file;
import std.json;
import dsfml.graphics;
import dsfml.audio;
import dspace.animation;


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

//
// Resource Manager
// Responsible for all file system IO. Currently just does a straight read,
// but should eventually pool/cache results.
//
class ResourceManager
{

    // Maximum cache item age in milliseconds (1 minute)
    private static immutable(uint) maxAge = 60000;

    SpriteResource[string]    spriteCache;
    FontResource[string]      fontCache;
    SoundResource[string]     soundCache;
    AnimationResource[string] animationCache;

    private const(string) mergePath(const(string) name)
    {
        return "content/" ~ name;
    }

    public void clean(float delta)
    {
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