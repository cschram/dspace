module dspace.resources;

import std.file;
import std.json;
import dsfml.graphics;
import dsfml.audio;
import dspace.animation;

//
// Resource Manager
// Responsible for all file system IO. Currently just does a straight read,
// but should eventually pool/cache results.
//
class ResourceManager {

    private const(string) mergePath(const(string) name) {
        return "content/" ~ name;
    }


    public Sprite getSprite(const(string) name) {
        auto tex = new Texture();
        if (!tex.loadFromFile(mergePath(name))) {
            throw new Exception("Could not load Sprite '" ~ name ~ "'.");
        }
        return new Sprite(tex);
    }

    public void releaseSprite(const(string) name) { }


    public Font getFont(const(string) name) {
        auto font = new Font();
        if (!font.loadFromFile(mergePath(name))) {
            throw new Exception("Could not load Font '" ~ name ~ "'.");
        }
        return font;
    }

    public void releaseFont(const(string) name) { }


    public Sound getSound(const(string) name) {
        auto buf = new SoundBuffer();
        if (!buf.loadFromFile(mergePath(name))) {
            throw new Exception("Could not load Sound '" ~ name ~ "'.");
        }
        return new Sound(buf);
    }

    public void releaseSound(const(string) name) { }


    public JSONValue getJSON(const(string) name) {
        return parseJSON(readText(mergePath(name)));
    }

    public void releaseJSON(const(string) name) { }


    public Animation getAnimation(const(string) name) {
        auto json = getJSON(name);
        auto sprite = getSprite(json.object["sprites"].str);
        return new Animation(sprite, json);
    }

    public void releaseAnimation(const(string) name) { }

}