import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:platformer_pixel_advanture/main.dart';
import 'package:platformer_pixel_advanture/player.dart';

class PlayerWallCallback extends ContactCallback<Player, Wall> {
  @override
  void begin(Player a, Wall b, Contact contact) {
    if (contact.fixtureA.isSensor || contact.fixtureB.isSensor) {
      footContactEvent.broadcast();
    }
  }
}
