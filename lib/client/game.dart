library game;

import 'dart:html';
import 'dart:math';

import 'colors.dart';
import 'keyboard.dart';
import 'worm.dart';
import 'level.dart';
import 'camera.dart';

class Game {
  CanvasRenderingContext2D context;
  CanvasElement canvas;
  List<Worm> worms = [];
  Keyboard keyboard = new Keyboard();
  Level level;
  Camera camera;

  int maxHeight = 800;
  int maxWidth = 1280;

  Game() {
    print('The game started.');

    canvas = document.querySelector('canvas');
    context = canvas.getContext('2d');

    final random = new Random();

    worms.add(
      new Worm()
        ..position = new Point(16, random.nextInt(256))
        ..color = COLORS[random.nextInt(COLORS.length)]
        ..game = this
    );

    for (var i = 0; i < 0; i++) {
      worms.add(
        new Worm()
          ..ai = true
          ..position = new Point(16, random.nextInt(256))
          ..color = COLORS[random.nextInt(COLORS.length)]
          ..game = this
      );
    }

    level = new Level(this);
    camera = new Camera(this);

    window.requestAnimationFrame(frame);
    window.onResize.listen((_) => resizeCanvas());

    resizeCanvas();
  }

  void resizeCanvas() {
    canvas.width = min(window.outerWidth, maxWidth);
    canvas.height = min(window.outerHeight, maxHeight);
  }

  void frame(double time) {
    context.fillStyle = 'black';
    context.fillRect(0, 0, maxWidth, maxHeight);

    camera.step();
    level.draw();
    worms.forEach((worm) => worm.step());

    window.requestAnimationFrame(frame);
  }

  double get cameraXShift => -camera.position.x;
  double get cameraYShift => -camera.position.y;
}
