import 'dart:async';
import 'dart:async' as async;
import 'dart:ui';

import 'package:event/event.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/parallax.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:platformer_pixel_advanture/callback/player_fruit_callback.dart';
import 'package:platformer_pixel_advanture/callback/player_wall_callback.dart';
import 'package:platformer_pixel_advanture/events/score_event.dart';
import 'package:platformer_pixel_advanture/fruit_collectable.dart';
import 'package:platformer_pixel_advanture/hud/level_component.dart';
import 'package:platformer_pixel_advanture/player.dart';
import 'package:platformer_pixel_advanture/sprite_animation_with_end_event.dart';
import 'package:tiled/tiled.dart';

import 'events/fruit_touched_event.dart';
import 'hud/score_componet.dart';
import 'hud/time_component.dart';
import 'player_sprite.dart';

const green = Color(0xff9fcc98);
const yellow = Color(0xffd9d4a3);
const blue = Color(0xffbccbd5);
const purple = Color(0xffdcaec1);
const gray = Color(0xffcccccc);
const pink = Color(0xffdcaec1);
const brown = Color(0xffd8bd9b);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();
  var fruitVallian = FruitVallian();
  runApp(GameWidget(
    game: fruitVallian,
    backgroundBuilder: (BuildContext context) {
      return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
              image: AssetImage('assets/images/pattern.png'),
              repeat: ImageRepeat.repeat),
        ),
        constraints: const BoxConstraints.expand(),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Container(
              color: green.withAlpha(130),
            ),
          ),
        ),
      );
    },
  ));
}

const scaleFactor = 10.0;
const double velocity = 15;
const velocityY = 20;
const halfVelocityY = 16;
// 5 meter perk height
// 3.2 meter perk height
final footContactEvent = Event();
final fruitContactEvent = Event<FruitTouchArgs>();
final scoreEvent = Event<ScoreArgs>();

class FruitVallian extends Forge2DGame
    with HasTappables, KeyboardEvents, HasDraggables {
  late JoystickComponent joystick;
  late Player player;
  late TimeComponent timeComponent;
  late ScoreComponent scoreComponent;
  late int score = 0;
  var seconds = 1;

  FruitVallian() : super(gravity: Vector2(0, 40), zoom: scaleFactor) {
    camera.viewport = FixedResolutionViewport(Vector2(512, 288));
  }

  @override
  void onDragUpdate(int pointerId, DragUpdateInfo info) {
    if (info.eventPosition.global.x < camera.viewport.canvasSize!.x / 2) {
      final playerSprite = player.playerSprite;
      var dx = info.raw.delta.dx;
      if (dx > 1) {
        if (playerSprite.transform.scale.x == -1) {
          playerSprite.flipHorizontally();
        }
        player.movingRight = true;
        player.movingLeft = false;
        playerSprite.current = PlayerState.run;
      } else if (dx < -1) {
        if (playerSprite.transform.scale.x == 1) {
          playerSprite.flipHorizontally();
        }
        player.movingLeft = true;
        player.movingRight = false;
        playerSprite.current = PlayerState.run;
      }
    }
    super.onDragUpdate(pointerId, info);
  }

  @override
  void onDragEnd(int pointerId, DragEndInfo info) {
    super.onDragEnd(pointerId, info);
    player.movingLeft = false;
    player.movingRight = false;
    player.body.linearVelocity = Vector2(0, player.body.linearVelocity.y);
  }

  @override
  void onTapUp(int pointerId, TapUpInfo info) {
    if (info.eventPosition.global.x > camera.viewport.canvasSize!.x / 2 &&
        player.canJump()) {
      final playerSprite = player.playerSprite;
      var jump = player.jump;
      var y = -player.body.mass * velocityY;
      var dy = -player.body.mass * halfVelocityY;
      player.body.linearVelocity = Vector2(player.body.linearVelocity.x, 0);
      if (jump == 0) {
        playerSprite.current = PlayerState.jump;
        player.body.applyLinearImpulse(Vector2(0, y));
      } else if (jump == 1) {
        playerSprite.current = PlayerState.doubleJump;
        player.body.applyLinearImpulse(Vector2(0, dy));
      }
      player.jump++;
    }
    super.onTapUp(pointerId, info);
  }

  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    var playerSprite = player.playerSprite;
    var jump = player.jump;
    if (event is RawKeyDownEvent) {
      var y = -player.body.mass * velocityY;
      var dy = -player.body.mass * halfVelocityY;
      if (keysPressed.contains(LogicalKeyboardKey.keyA) &&
          keysPressed.contains(LogicalKeyboardKey.space) &&
          player.canJump()) {
        player.movingLeft = true;
        player.body.linearVelocity = Vector2(-velocity, 0);
        if (playerSprite.transform.scale.x == 1) {
          playerSprite.flipHorizontally();
        }
        if (jump == 0) {
          playerSprite.current = PlayerState.jump;
          player.body.applyLinearImpulse(Vector2(0, y));
        } else if (jump == 1) {
          playerSprite.current = PlayerState.doubleJump;
          player.body.applyLinearImpulse(Vector2(0, dy));
        }
        player.jump++;
      } else if (keysPressed.contains(LogicalKeyboardKey.keyD) &&
          keysPressed.contains(LogicalKeyboardKey.space) &&
          player.canJump()) {
        player.movingRight = true;
        player.body.linearVelocity = Vector2(velocity, 0);
        if (playerSprite.transform.scale.x == -1) {
          playerSprite.flipHorizontally();
        }
        if (jump == 0) {
          playerSprite.current = PlayerState.jump;
          player.body.applyLinearImpulse(Vector2(0, y));
        } else if (jump == 1) {
          playerSprite.current = PlayerState.doubleJump;
          player.body.applyLinearImpulse(Vector2(0, dy));
        }
        player.jump++;
      } else if (keysPressed.contains(LogicalKeyboardKey.keyA)) {
        player.movingLeft = true;
        if (playerSprite.transform.scale.x == 1) {
          playerSprite.flipHorizontally();
        }
        playerSprite.current = PlayerState.run;
        player.body.linearVelocity =
            Vector2(-velocity, player.body.linearVelocity.y);
      } else if (keysPressed.contains(LogicalKeyboardKey.keyD)) {
        player.movingRight = true;
        if (playerSprite.transform.scale.x == -1) {
          playerSprite.flipHorizontally();
        }
        playerSprite.current = PlayerState.run;
        player.body.linearVelocity =
            Vector2(velocity, player.body.linearVelocity.y);
      } else if (keysPressed.contains(LogicalKeyboardKey.space) &&
          player.canJump()) {
        player.body.linearVelocity = Vector2(player.body.linearVelocity.x, 0);
        if (jump == 0) {
          playerSprite.current = PlayerState.jump;
          player.body.applyLinearImpulse(Vector2(0, y));
        } else if (jump == 1) {
          playerSprite.current = PlayerState.doubleJump;
          player.body.applyLinearImpulse(Vector2(0, dy));
        }
        player.jump++;
      }
    }

    if (event is RawKeyUpEvent &&
        (event.logicalKey == LogicalKeyboardKey.keyA ||
            event.logicalKey == LogicalKeyboardKey.keyD)) {
      if (event.logicalKey == LogicalKeyboardKey.keyA) {
        player.movingLeft = false;
      }
      if (event.logicalKey == LogicalKeyboardKey.keyD) {
        player.movingRight = false;
      }
      player.body.linearVelocity = Vector2(0, player.body.linearVelocity.y);
    }
    return super.onKeyEvent(event, keysPressed);
  }

  @override
  Future<void> onLoad() async {
    addContactCallback(PlayerWallCallback());
    addContactCallback(PlayerFruitCallback());
    final layers = {
      'bg/Green.png': 5.0,
    }.entries.map(
      (element) {
        var value = element.value;
        return loadParallaxLayer(ParallaxImageData(element.key),
            fill: LayerFill.none,
            repeat: ImageRepeat.repeat,
            velocityMultiplier: Vector2(0, value));
      },
    );

    var background = ParallaxComponent(
      parallax: Parallax(
        await Future.wait(layers),
        baseVelocity: Vector2(0, -10),
      ),
    );
    add(background);

    var map = await TiledComponent.load('level.tmx', Vector2.all(1.6));
    add(map);
    var objects = (map.tileMap.getLayer('body') as ObjectGroup).objects;
    var spawn = objects.firstWhere((element) => element.type == 'spawn');
    for (var element in objects) {
      var width = element.width / scaleFactor;
      var height = element.height / scaleFactor;
      var x = element.x / scaleFactor;
      var y = element.y / scaleFactor;
      final start = Vector2(x, y);
      var paint = Paint()..color = Colors.transparent;

      element.type.split('_').forEach((side) {
        switch (side) {
          case 'top':
            {
              add(Wall(start, Vector2(x + width, y), paint: paint));
              break;
            }
          case 'bottom':
            {
              add(Wall(
                  start + Vector2(0, height), Vector2(x + width, y + height),
                  paint: paint));
              break;
            }
          case 'left':
            {
              add(Wall(start, Vector2(x, y + height), paint: paint));
              break;
            }
          case 'right':
            {
              add(Wall(
                  start + Vector2(width, 0), Vector2(x + width, y + height),
                  paint: paint));
              break;
            }
          case 'apple':
            {
              add(FruitCollectable('fruits/apple.png', Vector2(x, y)));
              break;
            }
          case 'banana':
            {
              add(FruitCollectable('fruits/banana.png', Vector2(x, y)));
              break;
            }
          case 'cherry':
            {
              add(FruitCollectable('fruits/cherry.png', Vector2(x, y)));
              break;
            }
          case 'kiwi':
            {
              add(FruitCollectable('fruits/kiwi.png', Vector2(x, y)));
              break;
            }
          case 'melon':
            {
              add(FruitCollectable('fruits/melon.png', Vector2(x, y)));
              break;
            }
          case 'orange':
            {
              add(FruitCollectable('fruits/orange.png', Vector2(x, y)));
              break;
            }
          case 'pineapple':
            {
              add(FruitCollectable('fruits/pineapple.png', Vector2(x, y)));
              break;
            }
          case 'strawberry':
            {
              add(FruitCollectable('fruits/strawberry.png', Vector2(x, y)));
              break;
            }
          default:
            {
              break;
            }
        }
      });
    }

    fruitContactEvent.subscribe((args) async {
      if (args!.begin) {
        args.fruit.removeFromParent();
      } else {
        add(SpriteAnimationComponent(
            removeOnFinish: true,
            animation: await loadSpriteAnimation(
              'collected.png',
              SpriteAnimationData.sequenced(
                texturePosition: Vector2(0, 0),
                amount: 11,
                textureSize: Vector2(32, 32),
                stepTime: 0.05,
                loop: false,
              ),
            ))
          ..anchor = Anchor.center
          ..position = args.fruit.position
          ..size = Vector2(32, 32) / scaleFactor);
      }
    });

    scoreEvent.subscribe((args) {
      score += args!.score;
      scoreComponent.score = score;
    });

    var appearing = SpriteAnimationComponentWithEndEvent(() {
      player = Player(Vector2(spawn.x, spawn.y) / scaleFactor)..priority = 1;
      add(player);
    },
        removeOnFinish: true,
        animation: await loadSpriteAnimation(
            'appearing.png',
            SpriteAnimationData.sequenced(
              texturePosition: Vector2(0, 0),
              amount: 7,
              textureSize: Vector2(96, 96),
              stepTime: 0.1,
              loop: false,
            )))
      ..anchor = Anchor.center
      ..position = Vector2(spawn.x, spawn.y) / scaleFactor
      ..size = Vector2(96, 96) / scaleFactor;

    add(appearing);

    add(LevelComponent(1)
      ..position = Vector2(
          (camera.viewport.effectiveSize.x / (2 * scaleFactor)) -
              (16 + 10 * 5) / 2 / scaleFactor,
          2)
      ..size = Vector2(16, 16));

    scoreComponent = ScoreComponent(0)
      ..position = Vector2(
          camera.viewport.effectiveSize.x / scaleFactor -
              (16 + 10 * 23) / 2 / scaleFactor,
          2)
      ..size = Vector2(16, 16);
    add(scoreComponent);

    timeComponent = TimeComponent(1)
      ..position = Vector2(1.5, 2)
      ..size = Vector2(16, 16);
    add(timeComponent);

    async.Timer.periodic(const Duration(seconds: 1), (timer) {
      timeComponent.removeFromParent();
      timeComponent = TimeComponent(++seconds)
        ..position = Vector2(1.5, 2)
        ..size = Vector2(16, 16);
      add(timeComponent);
    });
  }
}
