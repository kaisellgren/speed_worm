library game;

import 'dart:html';
import 'dart:math';

import 'keyboard.dart';
import 'worm.dart';

class Game {
  CanvasRenderingContext2D context;
  CanvasElement canvas;
  List<Worm> worms = [];
  Keyboard keyboard = new Keyboard();

  int maxHeight = 800;

  Game() {
    print('The game started.');

    canvas = document.querySelector('canvas');
    context = canvas.getContext('2d');

    worms.add(
      new Worm()
        ..position = const Point(64, 64)
        ..color = 'green'
        ..game = this
    );

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
    context.fillRect(0, 0, canvas.width, maxHeight);

    worms.forEach((worm) => worm.step());

    window.requestAnimationFrame(frame);
  }
}
