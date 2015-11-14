module engine.configmgr;

import dsfml.graphics;

import engine.resourcemgr;

class ConfigManager
{
    static ConfigManager get()
    {
        if (!instantiated) {
            synchronized(ConfigManager.classinfo) {
                if (!instance) {
                    instance = new ConfigManager();
                }
                instantiated = true;
            }
        }

        return instance;
    }

    @property VideoMode videoMode() { return cfgVideoMode; }
    @property void videoMode(VideoMode mode)
    {
        cfgVideoMode = mode;
    }

    @property string windowTitle() { return cfgWindowTitle; }
    @property void windowTitle(string title)
    {
        cfgWindowTitle = title;
    }

    @property uint framerate() { return cfgFramerate; }
    @property void framerate(uint _framerate)
    {
        cfgFramerate = _framerate;
    }

private:
    static bool instantiated;
    static __gshared ConfigManager instance;
    this() {}

    VideoMode cfgVideoMode   = VideoMode(800, 600);
    string   cfgWindowTitle = "D Game Engine";
    uint      cfgFramerate   = 60;
}