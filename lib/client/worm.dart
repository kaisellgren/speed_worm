library worm;

import 'dart:math';
import 'game.dart';
import 'dart:html';
import 'colors.dart';

class Tail {
  Point left;
  Point right;

  Tail(this.left, this.right);
}

class Worm {
  Point position;
  Point previousPosition;
  double speed = 0.0;
  Point direction;
  double gravity = 0.1;
  int health = 100;
  int size = 32;
  bool ai = false;
  Color color;
  Game game;
  List<Tail> tails = [];
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

    if (previousPosition != null) {
      final length = new Point(previousPosition.x - position.x, previousPosition.y - position.y);
      final maxLength = max(length.x.abs(), length.y.abs());
      final normalized = new Point(length.x / maxLength, length.y / maxLength);
      final left = new Point(-normalized.y, normalized.x);
      final right = new Point(normalized.y, -normalized.x);
      direction = normalized;

      final leftX = position.x + left.x * size / 2;
      final leftY = position.y + left.y * size / 2;
      final rightX = position.x + right.x * size / 2;
      final rightY = position.y + right.y * size / 2;

      tails.insert(0, new Tail(new Point(leftX, leftY), new Point(rightX, rightY)));

      draw();
    }

    previousPosition = position;

    if (tails.length > 100) tails = tails.sublist(0, 100);
  }

  bool collides() {
    final imageData = game.level.imageData;
    final hit = (imageData.width * position.y.round() + position.x.round()) * 4;
    return imageData.data[hit] == 255;
  }

  void draw() {
    game.context
      ..beginPath()
      ..fillStyle = color.toString()
      ..moveTo(tails.first.left.x + game.cameraXShift, tails.first.left.y + game.cameraYShift);

    tails.skip(1).forEach((tail) {
      game.context.lineTo(tail.left.x + game.cameraXShift, tail.left.y + game.cameraYShift);
    });

    tails.reversed.forEach((tail) {
      game.context.lineTo(tail.right.x + game.cameraXShift, tail.right.y + game.cameraYShift);
    });

    game.context
      ..fill()
      ..closePath();

    if (collides()) {
      drawEllipse(position.x + game.cameraXShift, position.y - 64 + game.cameraYShift, size / 2, new Color(255, 0, 0));
      health = max(1, health - 1);

    }

    drawEllipse(position.x + game.cameraXShift, position.y + game.cameraYShift, size / 2, color);
  }

  void drawEllipse(num x, num y, size, Color color) {
    game.context
      ..beginPath()
      ..arc(x, y, size, 0, 2 * PI, false)
      ..fillStyle = color.toString()
      ..fill()
      ..closePath();
  }
}
