module game;

import std.stdio;

import dsfml.graphics;
import dsfml.audio;

import resources;
import player;

class Game {
private:

  static Game _instance;

  // Constants
  static float     scrollSpeed = 0.5;
  static VideoMode screenMode  = VideoMode(400, 600);

  // State
  RenderWindow    window;
  ResourceManager resources;
  bool            started;
  bool            moving;
  Player          player;

  this() {
    resources = new ResourceManager();
  }

public:

  static Game GetInstance() {
    if (_instance is null) {
      _instance = new Game();
    }
    return _instance;
  }

  ResourceManager Resources() {
    return resources;
  }

  void Run() {
    writeln("Loading...");

    window  = new RenderWindow(screenMode, "DSpace");
    started = false;
    moving  = false;

    window.setFramerateLimit(60);

    float backgroundPosition = 1800;

    // Images
    auto background = resources.getSprite("content/images/background.png");
    auto healthbar  = resources.getSprite("content/images/healthbar.png");
    auto gameover   = resources.getSprite("content/images/gameover.png");
    background.textureRect = IntRect(0, cast(int)backgroundPosition, 400, 600);

    // Text
    auto font = resources.getFont("content/fonts/slkscr.ttf");
    auto startText = new Text("Press Space to Start", font, 30);
    startText.position = Vector2f(8, 270);

    // Main loop
    writeln("Running...");
    while (window.isOpen()) {
      // Poll events
      Event e;
      while (window.pollEvent(e)) {
        switch (e.type) {
          default:
            break;

          // Close button event
          case e.EventType.Closed:
            window.close();
            break;

          // Keyboard input
          case e.EventType.KeyPressed:
            switch (e.key.code) {
              default:
                break;

              case Keyboard.Key.Space:
                started = true;
                moving  = true;
                break;
            }
            break;
        }
      }

      // Game logic
      if (started) {
        if (moving) {
          backgroundPosition -=  scrollSpeed;
          background.textureRect = IntRect(0, cast(int)backgroundPosition, 400, 600);
          moving = (backgroundPosition > 0);
        }
      }

      // Render
      window.clear();

      window.draw(background);

      if (started) {

      } else {
        window.draw(startText);
      }

      window.display();
    }
  }

  bool HasStarted() {
    return started;
  }

}