library camera;

import 'game.dart';
import 'dart:math';

class Camera {
  Game game;
  Point position = const Point(0, 0);

  Camera(this.game);

  void step() {
    final player = game.worms.firstWhere((worm) => worm.ai == false, orElse: () => null);

    if (player != null) {
      final x = player.position.x - game.canvas.width / 2;
      position = new Point(max(0, x), 0);

      // Let's pretend the player hit something.
      //player.size -= 0.03;
      //if (player.size < 2) player.size = 2;
    }
  }
}
