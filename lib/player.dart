import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:platformer_pixel_advanture/main.dart';
import 'package:platformer_pixel_advanture/player_sprite.dart';

class Player extends BodyComponent {
  final Vector2 position;
  var jump = 0;

  bool movingLeft = false;
  bool movingRight = false;

  late PlayerSprite playerSprite;

  Player(this.position);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    footContactEvent.subscribe((args) {
      jump = 0;
    });
    renderBody = false;
    playerSprite = PlayerSprite(
        'run.png', 'jump.png', 'doublejump.png', 'idle.png', 'fall.png',
        size: Vector2(32, 32) / scaleFactor)
      ..anchor = Anchor.center;
    add(playerSprite);
    body.setFixedRotation(true);
  }

  bool canJump() {
    if (jump < 2) {
      if (jump == 0) {
        return body.linearVelocity.y < epsilon;
      }
      return true;
    }
    return false;
  }

  @override
  void update(double dt) {
    if (movingLeft) {
      body.linearVelocity = Vector2(-velocity, body.linearVelocity.y);
    }
    if (movingRight) {
      body.linearVelocity = Vector2(velocity, body.linearVelocity.y);
    }
    if (body.linearVelocity == Vector2.zero() && children.isNotEmpty) {
      (children.first as PlayerSprite).current = PlayerState.idle;
    }
    if (jump == 0) {
      if (movingLeft || movingRight) {
        playerSprite.current = PlayerState.run;
      }
    }
    super.update(dt);
  }

  @override
  Body createBody() {
    var bodyDef = BodyDef();
    bodyDef.userData = this;
    bodyDef.position.setFrom(position);
    bodyDef.type = BodyType.dynamic;

    var bodyFixtureDef = FixtureDef(PolygonShape()
      ..setAsBox(
          12 / scaleFactor, 13 / scaleFactor, Vector2(0, 3) / scaleFactor, 0))
      ..restitution = 0
      ..friction = 0
      ..density = 1;
    var body = world.createBody(bodyDef);
    body.createFixture(bodyFixtureDef);

    var footFixtureDef = FixtureDef(PolygonShape()
      ..setAsBox(
          10 / scaleFactor, 1 / scaleFactor, Vector2(0, 16) / scaleFactor, 0))
      ..restitution = 0
      ..friction = 0
      ..isSensor = true
      ..userData = 'foot'
      ..density = 0;
    body.createFixture(footFixtureDef);
    return body;
  }
}

class Wall extends BodyComponent {
  final Vector2 start;
  final Vector2 end;

  Wall(this.start, this.end, {Paint? paint}) : super(paint: paint);

  @override
  Body createBody() {
    final shape = EdgeShape()..set(start, end);

    final fixtureDef = FixtureDef(shape)
      ..userData = 'wall'
      ..restitution = 0.0
      ..friction = 0;

    final bodyDef = BodyDef()
      ..userData = this
      ..type = BodyType.static;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
