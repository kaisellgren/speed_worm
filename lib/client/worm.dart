library worm;

import 'dart:math';
import 'game.dart';
import 'dart:html';

class Worm {
  Point position;
  double speed = 0.0;
  double gravity = 0.1;
  int size = 8;
  String color;
  Game game;
  List<Point> previousPositions = [];

  void step() {
    previousPositions.insert(0, position);

    // Movement.
    if (game.keyboard.isPressed(KeyCode.SPACE)) {
      gravity -= position.y / game.maxHeight;
    } else {
      gravity += position.y / game.maxHeight;
    }

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

    // Draw the position and previous position with more opacity.
    draw(position: position, opacity: 1.0);

    for (var i = 0, length = previousPositions.length; i < length; i++) {
      draw(position: previousPositions[i], opacity: 1 - i / 100);
    }

    if (previousPositions.length > 100) previousPositions = previousPositions.sublist(0, 100);
  }

  void draw({Point position, double opacity}) {
    var gradient = game.context.createRadialGradient(position.x, position.y, 0, position.x, position.y, size);
    gradient.addColorStop(0.2, '#6bc600');
    gradient.addColorStop(0.8, '#437b00');

    game.context.beginPath();
    game.context.globalAlpha = opacity;
    game.context.arc(position.x, position.y, size, 0, 2 * PI, false);
    game.context.fillStyle = gradient;
    game.context.fill();
    game.context.globalAlpha = 1;
  }
}
