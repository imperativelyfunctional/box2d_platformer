import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import 'level_component.dart';

class TimeComponent extends SpriteComponent with HasGameRef {
  final int time;

  TimeComponent(this.time);

  @override
  Future<void>? onLoad() async {
    priority = 2;
    final image = await gameRef.images.load('number_w.png');
    sprite =
        Sprite(image, srcPosition: Vector2(144, 16), srcSize: Vector2(16, 16));
    var scaledDownSize = Vector2(16, 16) / scaleFactor;
    size = scaledDownSize;
    add(SpriteComponent(
        sprite: Sprite(image,
            srcPosition: Vector2(126, 0), srcSize: Vector2(16, 16)))
      ..position = Vector2(8 / scaleFactor, 0)
      ..size = scaledDownSize);
    add(SpriteComponent(
        sprite: Sprite(image,
            srcPosition: Vector2(32, 16), srcSize: Vector2(16, 16)))
      ..position = Vector2(spacing * 2 / scaleFactor, 0)
      ..size = scaledDownSize);
    add(SpriteComponent(
        sprite: Sprite(image,
            srcPosition: Vector2(64, 0), srcSize: Vector2(16, 16)))
      ..position = Vector2(spacing * 3 / scaleFactor, 0)
      ..size = scaledDownSize);

    add(SpriteComponent(
        sprite: Sprite(image,
            srcPosition: Vector2(32, 64), srcSize: Vector2(16, 16)))
      ..position = Vector2(spacing * 4 / scaleFactor, 0)
      ..size = scaledDownSize);

    add(SpriteComponent(
        sprite: Sprite(image,
            srcPosition: Vector2(16 * (time ~/ 1000 % 10), 48),
            srcSize: Vector2(16, 16)))
      ..position = Vector2(spacing * 5 / scaleFactor, 0)
      ..size = scaledDownSize
      ..add(ColorEffect(Colors.pink, const Offset(1, 1),
          EffectController(duration: 1, infinite: true))));

    add(SpriteComponent(
        sprite: Sprite(image,
            srcPosition: Vector2(16 * (time ~/ 100 % 10), 48),
            srcSize: Vector2(16, 16)))
      ..position = Vector2(spacing * 6 / scaleFactor, 0)
      ..size = scaledDownSize
      ..add(ColorEffect(Colors.pink, const Offset(1, 1),
          EffectController(duration: 1, infinite: true))));

    add(SpriteComponent(
        sprite: Sprite(image,
            srcPosition: Vector2(16 * (time ~/ 10 % 10), 48),
            srcSize: Vector2(16, 16)))
      ..position = Vector2(spacing * 7 / scaleFactor, 0)
      ..size = scaledDownSize
      ..add(ColorEffect(Colors.pink, const Offset(1, 1),
          EffectController(duration: 1, infinite: true))));

    add(SpriteComponent(
        sprite: Sprite(image,
            srcPosition: Vector2(16 * (time % 10), 48),
            srcSize: Vector2(16, 16)))
      ..position = Vector2(spacing * 8 / scaleFactor, 0)
      ..size = scaledDownSize
      ..add(ColorEffect(Colors.pink, const Offset(1, 1),
          EffectController(duration: 1, infinite: true))));

    return super.onLoad();
  }
}
