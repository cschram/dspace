module resources;

import dsfml.graphics;
import dsfml.audio;

class Resource(T) {
  T   data;
  int refs;

  this(T d) {
    data = d;
    refs = 1;
  }
}

alias Resource!(Sprite) SpriteResource;
alias Resource!(Font)   FontResource;
alias Resource!(Sound)  SoundResource;

class ResourceManager {
private:

  SpriteResource[string] rSprites;
  FontResource[string]   rFonts;
  SoundResource[string]  rSounds;

public:

  Sprite getSprite(const(string) name) {
    if (name in rSprites) {
      auto sprite = rSprites[name];
      sprite.refs++;
      return sprite.data;
    } else {
      auto tex = new Texture();
      if (!tex.loadFromFile(name)) {
        throw new Exception("Could not load Sprite '" ~ name ~ "'.");
      }
      auto sprite = new Sprite(tex);
      rSprites[name] = new SpriteResource(sprite);
      return sprite;
    }
  }

  void releaseSprite(const(string) name) {
    if (name in rSprites) {
      auto sprite = rSprites[name];
      sprite.refs--;
      if (sprite.refs == 0) {
        rSprites.remove(name);
      }
    }
  }

  Font getFont(const(string) name) {
    if (name in rFonts) {
      auto font = rFonts[name];
      font.refs++;
      return font.data;
    } else {
      auto font = new Font();
      if (!font.loadFromFile(name)) {
        throw new Exception("Could not load Font '" ~ name ~ "'.");
      }
      rFonts[name] = new FontResource(font);
      return font;
    }
  }

  void releaseFont(const(string) name) {
    if (name in rFonts) {
      auto font = rFonts[name];
      font.refs--;
      if (font.refs == 0) {
        rFonts.remove(name);
      }
    }
  }

  Sound getSound(const(string) name) {
    if (name in rSounds) {
      auto sound = rSounds[name];
      sound.refs++;
      return sound.data;
    } else {
      auto buf = new SoundBuffer();
      if (!buf.loadFromFile(name)) {
        throw new Exception("Could not load Sound '" ~ name ~ "'.");
      }
      auto sound = new Sound(buf);
      rSounds[name] = new SoundResource(sound);
      return sound;
    }
  }

  void releaseSound(const(string) name) {
    if (name in rSounds) {
      auto sound = rSounds[name];
      sound.refs--;
      if (sound.refs == 0) {
        rSounds.remove(name);
      }
    }
  }
}