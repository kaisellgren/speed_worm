library keyboard;

import 'dart:collection';
import 'dart:html';

class Keyboard {
  HashMap<int, int> keys = new HashMap<int, int>();

  Keyboard() {
    window.onKeyDown.listen((KeyboardEvent e) {
      // If the key is not set yet, set it with a timestamp.
      if (!keys.containsKey(e.keyCode)) {
        keys[e.keyCode] = e.timeStamp;
      }
    });

    window.onKeyUp.listen((KeyboardEvent e) => keys.remove(e.keyCode));
  }

  isPressed(int keyCode) => keys.containsKey(keyCode);
}
