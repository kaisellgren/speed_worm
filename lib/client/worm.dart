library worm;

import 'dart:math';
import 'game.dart';
import 'dart:html';
import 'colors.dart';

class Worm {
  Point position;
  double speed = 0.0;
  double gravity = 0.1;
  int size = 8;
  bool ai = false;
  Color color;
  Game game;
  List<Point> previousPositions = [];
  Random random = new Random();

  void goUpwards() {
    gravity -= position.y / game.maxHeight * 2;
  }

  void step() {
    // AI.
    if (ai) {
      if (random.nextBool()) goUpwards();
    }

    // Movement.
    if (game.keyboard.isPressed(KeyCode.SPACE) && !ai) {
      goUpwards();
    }

    gravity += position.y / game.maxHeight;

    speed = position.y / 50;
    position = new Point(position.x + speed, position.y + gravity);

    // Just for now limit the movement.
    if (position.y <= size) {
      position = new Point(position.x, size);
      gravity = 0.1;
    }

    if (position.y >= game.maxHeight - size) {
      position = new Point(position.x, game.maxHeight - size);
      gravity = 0.0;
    }

    previousPositions.insert(0, position);

    draw();

    if (previousPositions.length > 100) previousPositions = previousPositions.sublist(0, 100);
  }

  void draw() {
    for (var i = 0, length = previousPositions.length; i < length - 1; i++) {
      final alpha = 1 - i /100;

      game.context
        ..beginPath()
        ..lineWidth = size
        ..strokeStyle = 'rgba(${color.red}, ${color.green}, ${color.blue}, $alpha)'
        ..moveTo(previousPositions[i].x + game.cameraXShift, previousPositions[i].y + game.cameraYShift)
        ..lineTo(previousPositions[i + 1].x + game.cameraXShift, previousPositions[i + 1].y + game.cameraYShift)
        ..stroke()
        ..closePath();
    }
  }
}
