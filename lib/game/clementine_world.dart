import 'package:flame/components.dart';

import '../components/environment/ground.dart';
import '../components/obstacles/obstacle.dart';
import '../components/obstacles/obstacle_spawner.dart';
import '../components/environment/tokyo_parallax.dart';
import '../components/player/player.dart';

class ClementineWorld extends World {
  late final Player player;
  late final ObstacleSpawner obstacleSpawner;

  @override
  Future<void> onLoad() async {
    await add(TokyoParallax());
    await add(Ground());
    player = Player();
    await add(player);
    obstacleSpawner = ObstacleSpawner();
    await add(obstacleSpawner);
  }

  void resetRun() {
    player.reset();
    obstacleSpawner.reset();

    final obstacles = children.query<Obstacle>().toList();
    for (final obstacle in obstacles) {
      obstacle.removeFromParent();
    }
  }
}
