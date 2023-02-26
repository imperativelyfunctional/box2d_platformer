import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:platformer_pixel_advanture/main.dart';

const int spacing = 10;

class LevelComponent extends SpriteComponent with HasGameRef {
  final int round;

  LevelComponent(this.round);

  @override
  Future<void>? onLoad() async {
    priority = 2;
    final image = await gameRef.images.load('number_w.png');
    sprite =
        Sprite(image, srcPosition: Vector2(16, 16), srcSize: Vector2(16, 16));
    var scaledDownSize = Vector2(16, 16) / scaleFactor;
    size = scaledDownSize;
    add(SpriteComponent(
        sprite: Sprite(image,
            srcPosition: Vector2(16, 32), srcSize: Vector2(16, 16)))
      ..position = Vector2(spacing / scaleFactor, 0)
      ..size = scaledDownSize);
    add(SpriteComponent(
        sprite: Sprite(image,
            srcPosition: Vector2(16, 16), srcSize: Vector2(16, 16)))
      ..position = Vector2(spacing * 2 / scaleFactor, 0)
      ..size = scaledDownSize);
    add(SpriteComponent(
        sprite: Sprite(image,
            srcPosition: Vector2(32, 64), srcSize: Vector2(16, 16)))
      ..position = Vector2(spacing * 3 / scaleFactor, 0)
      ..size = scaledDownSize);

    var ten = round ~/ 10;
    var one = round % 10;
    add(SpriteComponent(
        sprite: Sprite(image,
            srcPosition: Vector2(16 * (ten % 10), 48),
            srcSize: Vector2(16, 16)))
      ..add(ColorEffect(Colors.amber, const Offset(1, 1),
          EffectController(duration: 1, infinite: true)))
      ..position = Vector2(spacing * 4 / scaleFactor, 0)
      ..size = scaledDownSize);

    add(SpriteComponent(
        sprite: Sprite(image,
            srcPosition: Vector2(16 * (one % 10), 48),
            srcSize: Vector2(16, 16)))
      ..add(ColorEffect(Colors.amber, const Offset(1, 1),
          EffectController(duration: 1, infinite: true)))
      ..position = Vector2(spacing * 5 / scaleFactor, 0)
      ..size = scaledDownSize);

    return super.onLoad();
  }
}
