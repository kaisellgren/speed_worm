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
  int size = 8192;
  List<Shape> shapes = [];
  Random random = new Random();
  ImageData imageData;

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

    _createCollisionMap();
  }

  void _createCollisionMap() {
    var canvas = new CanvasElement()
      ..width = size
      ..height = game.maxHeight
      ..context2D.fillStyle = 'black'
      ..context2D.fillRect(0, 0, size, game.maxHeight);

    _drawInternal(canvas.context2D, 0, 0, '#fff');
    imageData = canvas.context2D.getImageData(0, 0, size, game.maxHeight);
  }

  void draw() {
    _drawInternal(game.context, game.cameraXShift, game.cameraYShift, '#764e00');
  }

  void _drawInternal(CanvasRenderingContext2D context, num xOffset, num yOffset, String color) {
    shapes.forEach((shape) {
      context
        ..beginPath()
        ..fillStyle = color
        ..moveTo(shape.points.first.x + xOffset, shape.points.first.y + yOffset);

      for (var i = 1, length = shape.points.length; i < length; i++) {
        context
          ..lineTo(shape.points[i].x + xOffset, shape.points[i].y + yOffset);
      }

      context
        ..fill()
        ..closePath();
    });
  }
}
