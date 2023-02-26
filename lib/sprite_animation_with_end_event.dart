import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';

class SpriteAnimationComponentWithEndEvent extends SpriteAnimationComponent {
  final VoidCallback callback;

  SpriteAnimationComponentWithEndEvent(
    this.callback, {
    SpriteAnimation? animation,
    bool? removeOnFinish,
    bool? playing,
    Paint? paint,
    Vector2? position,
    Vector2? size,
    Vector2? scale,
    double? angle,
    Anchor? anchor,
    Iterable<Component>? children,
    int? priority,
  }) : super(
          removeOnFinish: removeOnFinish,
          animation: animation,
          position: position,
          size: size,
          scale: scale,
          angle: angle,
          anchor: anchor,
          children: children,
          priority: priority,
        );

  @override
  void update(double dt) {
    super.update(dt);
    if (removeOnFinish && (animation?.done() ?? false)) {
      callback.call();
    }
  }
}
