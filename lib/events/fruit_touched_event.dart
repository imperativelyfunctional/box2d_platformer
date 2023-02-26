import 'package:event/event.dart';
import 'package:platformer_pixel_advanture/fruit_collectable.dart';

class FruitTouchArgs extends EventArgs {
  final FruitCollectable fruit;
  final bool begin;

  FruitTouchArgs(this.fruit, this.begin);
}
