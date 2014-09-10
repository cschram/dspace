module ship;

import dsfml.graphics;

interface Ship {
  bool Hit(int damage);
  bool IsDestroyed();
}