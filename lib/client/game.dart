library game;

import 'dart:html';
import 'dart:math';

import 'colors.dart';
import 'keyboard.dart';
import 'worm.dart';
import 'level.dart';

class Game {
  CanvasRenderingContext2D context;
  CanvasElement canvas;
  List<Worm> worms = [];
  Keyboard keyboard = new Keyboard();
  Level level;

  int maxHeight = 800;
  int maxWidth = 1280;

  Game() {
    print('The game started.');

    canvas = document.querySelector('canvas');
    context = canvas.getContext('2d');

    final random = new Random();

    for (var i = 0; i < 1; i++) {
      worms.add(
        new Worm()
          ..ai = false
          ..position = new Point(16, random.nextInt(256))
          ..color = COLORS[random.nextInt(COLORS.length)]
          ..game = this
      );
    }

    level = new Level(this);

    window.requestAnimationFrame(frame);
    window.onResize.listen((_) => resizeCanvas());

    resizeCanvas();
  }

  void resizeCanvas() {
    canvas.width = window.outerWidth;
    canvas.height = window.outerHeight;
  }

  void frame(double time) {
    context.fillStyle = 'black';
    context.fillRect(0, 0, maxWidth, maxHeight);

    level.draw();
    worms.forEach((worm) => worm.step());

    window.requestAnimationFrame(frame);
  }
}
