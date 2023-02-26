import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:platformer_pixel_advanture/main.dart';

class FruitCollectable extends BodyComponent {
  final String path;
  final Vector2 position;
  bool begin = false;
  bool end = false;

  FruitCollectable(this.path, this.position);

  @override
  Body createBody() {
    var bodyDef = BodyDef();
    bodyDef.userData = this;
    bodyDef.position.setFrom(position);
    bodyDef.type = BodyType.kinematic;

    var fixtureDef = FixtureDef(
        PolygonShape()
          ..setAsBox(8 / scaleFactor, 9 / scaleFactor,
              Vector2(0, -1) / scaleFactor, 0),
        restitution: 0,
        friction: 0)
      ..isSensor = true;
    var body = world.createBody(bodyDef);
    body.createFixture(fixtureDef);
    return body;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    renderBody = false;
    add(SpriteAnimationComponent(
        animation: await gameRef.loadSpriteAnimation(
      path,
      SpriteAnimationData.sequenced(
        texturePosition: Vector2(0, 0),
        amount: 17,
        textureSize: Vector2(32, 32),
        stepTime: 0.05,
        loop: true,
      ),
    ))
      ..size = (Vector2(32, 32) / scaleFactor)
      ..anchor = Anchor.center);
    body.setFixedRotation(true);
  }
}
