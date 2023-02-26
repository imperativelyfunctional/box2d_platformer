import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:platformer_pixel_advanture/events/fruit_touched_event.dart';
import 'package:platformer_pixel_advanture/events/score_event.dart';
import 'package:platformer_pixel_advanture/fruit_collectable.dart';
import 'package:platformer_pixel_advanture/main.dart';
import 'package:platformer_pixel_advanture/player.dart';

class PlayerFruitCallback extends ContactCallback<Player, FruitCollectable> {
  @override
  void begin(Player a, FruitCollectable b, Contact contact) {
    if (!b.begin) {
      b.begin = true;
      fruitContactEvent.broadcast(FruitTouchArgs(b, true));
    }
  }

  @override
  void end(Player a, FruitCollectable b, Contact contact) {
    if (!b.end) {
      b.end = true;
      fruitContactEvent.broadcast(FruitTouchArgs(b, false));
      scoreEvent.broadcast(ScoreArgs(10));
    }
  }
}
