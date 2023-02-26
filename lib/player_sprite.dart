import 'package:flame/components.dart';

enum PlayerState {
  idle,
  run,
  jump,
  doubleJump,
  fall,
}

class PlayerSprite extends SpriteAnimationGroupComponent<PlayerState>
    with HasGameRef {
  final String run;
  final String jump;
  final String doubleJump;
  final String idle;
  final String fall;

  PlayerSprite(
    this.run,
    this.jump,
    this.doubleJump,
    this.idle,
    this.fall, {
    required Vector2 size,
  }) : super(size: size);

  @override
  Future<void>? onLoad() async {
    final idle = await gameRef.loadSpriteAnimation(
      this.idle,
      SpriteAnimationData.sequenced(
        texturePosition: Vector2(0, 0),
        amount: 11,
        textureSize: Vector2(32, 32),
        stepTime: 0.05,
        loop: true,
      ),
    );

    final run = await gameRef.loadSpriteAnimation(
      this.run,
      SpriteAnimationData.sequenced(
        texturePosition: Vector2(0, 0),
        amount: 12,
        textureSize: Vector2(32, 32),
        stepTime: 0.05,
        loop: true,
      ),
    );

    final jump = await gameRef.loadSpriteAnimation(
      this.jump,
      SpriteAnimationData.sequenced(
        amount: 1,
        textureSize: Vector2(32, 32),
        texturePosition: Vector2(0, 0),
        stepTime: 10,
      ),
    );

    final doubleJump = await gameRef.loadSpriteAnimation(
      this.doubleJump,
      SpriteAnimationData.sequenced(
        amount: 6,
        textureSize: Vector2(32, 32),
        texturePosition: Vector2(0, 0),
        stepTime: 0.05,
        loop: true,
      ),
    );

    final fall = await gameRef.loadSpriteAnimation(
      this.fall,
      SpriteAnimationData.sequenced(
        amount: 1,
        textureSize: Vector2(32, 32),
        texturePosition: Vector2(0, 0),
        stepTime: 10,
      ),
    );

    animations = {
      PlayerState.idle: idle,
      PlayerState.jump: jump,
      PlayerState.doubleJump: doubleJump,
      PlayerState.run: run,
      PlayerState.fall: fall,
    };
    current = PlayerState.idle;
    return super.onLoad();
  }
}
