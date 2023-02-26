import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import 'level_component.dart';

class ScoreComponent extends SpriteComponent with HasGameRef {
  int score;
  var image;
  late int _lastScore;
  final scaledDownSize = Vector2(16, 16) / scaleFactor;

  ScoreComponent(this.score);

  @override
  void update(double dt) {
    if (_lastScore != score) {
      remove(children.elementAt(children.length - 1));
      remove(children.elementAt(children.length - 2));
      remove(children.elementAt(children.length - 3));
      remove(children.elementAt(children.length - 4));
      add(SpriteComponent(
          sprite: Sprite(image,
              srcPosition: Vector2(16 * (score ~/ 1000 % 10), 48),
              srcSize: Vector2(16, 16)))
        ..position = Vector2(spacing * 6 / scaleFactor, 0)
        ..size = scaledDownSize
        ..add(ColorEffect(Colors.indigo, const Offset(1, 1),
            EffectController(duration: 1, infinite: true))));

      add(SpriteComponent(
          sprite: Sprite(image,
              srcPosition: Vector2(16 * (score ~/ 100 % 10), 48),
              srcSize: Vector2(16, 16)))
        ..position = Vector2(spacing * 7 / scaleFactor, 0)
        ..size = scaledDownSize
        ..add(ColorEffect(Colors.indigo, const Offset(1, 1),
            EffectController(duration: 1, infinite: true))));

      add(SpriteComponent(
          sprite: Sprite(image,
              srcPosition: Vector2(16 * (score ~/ 10 % 10), 48),
              srcSize: Vector2(16, 16)))
        ..position = Vector2(spacing * 8 / scaleFactor, 0)
        ..size = scaledDownSize
        ..add(ColorEffect(Colors.indigo, const Offset(1, 1),
            EffectController(duration: 1, infinite: true))));

      add(SpriteComponent(
          sprite: Sprite(image,
              srcPosition: Vector2(16 * (score % 10), 48),
              srcSize: Vector2(16, 16)))
        ..position = Vector2(spacing * 9 / scaleFactor, 0)
        ..size = scaledDownSize
        ..add(ColorEffect(Colors.indigo, const Offset(1, 1),
            EffectController(duration: 1, infinite: true))));
      _lastScore = score;
    }
    super.update(dt);
  }

  @override
  Future<void>? onLoad() async {
    _lastScore = score;
    priority = 2;
    image = await gameRef.images.load('number_w.png');
    sprite =
        Sprite(image, srcPosition: Vector2(128, 16), srcSize: Vector2(16, 16));
    size = scaledDownSize;
    add(SpriteComponent(
        sprite: Sprite(image,
            srcPosition: Vector2(32, 0), srcSize: Vector2(16, 16)))
      ..position = Vector2(spacing / scaleFactor, 0)
      ..size = scaledDownSize);
    add(SpriteComponent(
        sprite: Sprite(image,
            srcPosition: Vector2(64, 16), srcSize: Vector2(16, 16)))
      ..position = Vector2(spacing * 2 / scaleFactor, 0)
      ..size = scaledDownSize);
    add(SpriteComponent(
        sprite: Sprite(image,
            srcPosition: Vector2(112, 16), srcSize: Vector2(16, 16)))
      ..position = Vector2(spacing * 3 / scaleFactor, 0)
      ..size = scaledDownSize);
    add(SpriteComponent(
        sprite: Sprite(image,
            srcPosition: Vector2(64, 0), srcSize: Vector2(16, 16)))
      ..position = Vector2(spacing * 4 / scaleFactor, 0)
      ..size = scaledDownSize);
    add(SpriteComponent(
        sprite: Sprite(image,
            srcPosition: Vector2(32, 64), srcSize: Vector2(16, 16)))
      ..position = Vector2(spacing * 5 / scaleFactor, 0)
      ..size = scaledDownSize);

    add(SpriteComponent(
        sprite: Sprite(image,
            srcPosition: Vector2(16 * (score ~/ 1000 % 10), 48),
            srcSize: Vector2(16, 16)))
      ..position = Vector2(spacing * 6 / scaleFactor, 0)
      ..size = scaledDownSize
      ..add(ColorEffect(Colors.indigo, const Offset(1, 1),
          EffectController(duration: 1, infinite: true))));

    add(SpriteComponent(
        sprite: Sprite(image,
            srcPosition: Vector2(16 * (score ~/ 100 % 10), 48),
            srcSize: Vector2(16, 16)))
      ..position = Vector2(spacing * 7 / scaleFactor, 0)
      ..size = scaledDownSize
      ..add(ColorEffect(Colors.indigo, const Offset(1, 1),
          EffectController(duration: 1, infinite: true))));

    add(SpriteComponent(
        sprite: Sprite(image,
            srcPosition: Vector2(16 * (score ~/ 10 % 10), 48),
            srcSize: Vector2(16, 16)))
      ..position = Vector2(spacing * 8 / scaleFactor, 0)
      ..size = scaledDownSize
      ..add(ColorEffect(Colors.indigo, const Offset(1, 1),
          EffectController(duration: 1, infinite: true))));

    add(SpriteComponent(
        sprite: Sprite(image,
            srcPosition: Vector2(16 * (score % 10), 48),
            srcSize: Vector2(16, 16)))
      ..position = Vector2(spacing * 9 / scaleFactor, 0)
      ..size = scaledDownSize
      ..add(ColorEffect(Colors.indigo, const Offset(1, 1),
          EffectController(duration: 1, infinite: true))));

    return super.onLoad();
  }
}
