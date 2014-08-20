library level;

import 'dart:html';
import 'dart:math';
import 'game.dart';

class Shape {
  List<Point> points = [];
  Shape(this.points);
}

class Level {
  Game game;
  int size = 4096;
  List<Shape> shapes = [];
  Random random = new Random();

  Level(this.game) {
    // Bottom ground.
    final minLevel = game.maxHeight - 8;
    var x = 0,
        y = minLevel,
        points = [],
        direction = -0.05;

    while (x < size) {
      points.add(new Point(x, y));

      y += direction;

      direction += (random.nextDouble() - random.nextDouble()) / 3;

      if (direction < -2) direction = -2;
      if (direction > 2) direction = 2;

      if (y < game.maxHeight / 2) {
        direction += random.nextDouble();
        y = game.maxHeight / 2 - random.nextDouble() * 5 + random.nextDouble() * 5;
      }

      if (y >= minLevel) {
        y = minLevel;
        direction = -0.05;
      }

      x += 1;
    }

    points.add(new Point(size, game.maxHeight));
    points.add(new Point(0, game.maxHeight));

    shapes.add(new Shape(points));

    /*shapes.add(
      new Shape([const Point(0, 700), const Point(700, 700), const Point(600, 650), const Point(32, 640)])
    );*/
  }

  void draw() {
    shapes.forEach((shape) {
      game.context
        ..fillStyle = '#764e00'
        ..moveTo(shape.points.first.x, shape.points.first.y);

      for (var i = 1, length = shape.points.length; i < length; i++) {
        game.context
          ..lineTo(shape.points[i].x, shape.points[i].y);
      }

      game.context
        ..fill()
        ..closePath();
    });
  }
}
