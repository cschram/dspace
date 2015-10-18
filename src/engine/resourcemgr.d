module engine.resourcemgr;

import std.file;
import std.json;

import dsfml.graphics;
import dsfml.audio;

import engine.cache;
import engine.graphics.animation;
import engine.graphics.animationset;

synchronized final abstract class ResourceManager
{
    private static immutable(float) maxAge = 60;

    private __gshared Cache!JSONValue    jsonCache;
    private __gshared Cache!Texture      textureCache;
    private __gshared Cache!Font         fontCache;
    private __gshared Cache!SoundBuffer  soundCache;

    static this()
    {
        jsonCache    = new Cache!JSONValue(maxAge);
        textureCache = new Cache!Texture(maxAge);
        fontCache    = new Cache!Font(maxAge);
        soundCache   = new Cache!SoundBuffer(maxAge);
    }

    private static string mergePath(string name)
    {
        return "content/" ~ name;
    }

    static void collect(float delta)
    {
        jsonCache.collect(delta);
        textureCache.collect(delta);
        fontCache.collect(delta);
        soundCache.collect(delta);
    }

    static void flush()
    {
        jsonCache.empty();
        textureCache.empty();
        fontCache.empty();
        soundCache.empty();
    }

    static JSONValue getJSON(string name)
    {
        if (jsonCache.has(name)) {
            return jsonCache.get(name);
        } else {
            auto json = parseJSON(readText(mergePath(name)));
            jsonCache.set(name, json);
            return json;
        }
    }

    static Sprite getSprite(string name)
    {
        if (textureCache.has(name)) {
            return new Sprite(textureCache.get(name));
        } else {
            auto tex = new Texture();
            if (!tex.loadFromFile(mergePath(name))) {
                throw new Exception("Could not load Sprite '" ~ name ~ "'.");
            }
            textureCache.set(name, tex);
            return new Sprite(tex);
        }
    }

    static Font getFont(string name)
    {
        if (fontCache.has(name)) {
            return fontCache.get(name);
        } else {
            auto font = new Font();
            if (!font.loadFromFile(mergePath(name))) {
                throw new Exception("Could not load Font '" ~ name ~ "'.");
            }
            fontCache.set(name, font);
            return font;
        }
    }

    static Sound getSound(string name)
    {
        if (soundCache.has(name)) {
            return new Sound(soundCache.get(name));
        } else {
            auto buf = new SoundBuffer();
            if (!buf.loadFromFile(mergePath(name))) {
                throw new Exception("Could not load Sound '" ~ name ~ "'.");
            }
            soundCache.set(name, buf);
            return new Sound(buf);
        }
    }
}