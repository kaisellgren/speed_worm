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
  double gravity = 0.1;
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

  void draw() {
    for (var i = 0, length = tails.length; i < length - 1; i++) {
      final opacity = 1 - 1 / (tails.length / i);
      final tail = tails[i];
      final sideTail = tails[i + 1];

      game.context
        ..beginPath()
        ..fillStyle = color.toRgba(opacity)
        ..moveTo(tail.left.x + game.cameraXShift, tail.left.y + game.cameraYShift)
        ..lineTo(tail.right.x + game.cameraXShift, tail.right.y + game.cameraYShift)
        ..lineTo(sideTail.right.x + game.cameraXShift, sideTail.right.y + game.cameraYShift)
        ..lineTo(sideTail.left.x + game.cameraXShift, sideTail.left.y + game.cameraYShift)
        ..lineTo(tail.left.x + game.cameraXShift, tail.left.y + game.cameraYShift)
        ..fill()
        ..closePath();
    }

    drawEllipse(position.x + game.cameraXShift, position.y + game.cameraYShift, size / 2, color);
  }

  void drawEllipse(num x, num y, size, Color color) {
    game.context.beginPath();
    game.context.arc(x, y, size, 0, 2 * PI, false);
    game.context.fillStyle = color.toString();
    game.context.fill();
    game.context.closePath();
  }
}
