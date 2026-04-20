import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';

import '../../game/clementine_game.dart';
import '../../systems/game_state.dart';
import 'obstacle.dart';

class ObstacleSpawner extends Component with HasGameReference<ClementineGame> {
  ObstacleSpawner({Random? random}) : _random = random ?? Random();

  final Random _random;
  double _timeUntilNextSpawn = 1.4;

  @override
  void update(double dt) {
    super.update(dt);

    if (game.gameState != GameState.playing) {
      return;
    }

    _timeUntilNextSpawn -= dt;
    if (_timeUntilNextSpawn > 0) {
      return;
    }

    parent?.add(_buildObstacle());
    _timeUntilNextSpawn = _nextSpawnDelay();
  }

  void reset() {
    _timeUntilNextSpawn = 1.2;
  }

  Obstacle _buildObstacle() {
    final variants = <({double width, double height, int body, int accent})>[
      (width: 90, height: 46, body: 0xFFDC2626, accent: 0xFFFCA5A5),
      (width: 104, height: 50, body: 0xFFF59E0B, accent: 0xFFFDE68A),
      (width: 96, height: 48, body: 0xFF0EA5E9, accent: 0xFFBAE6FD),
      (width: 112, height: 54, body: 0xFF8B5CF6, accent: 0xFFD8B4FE),
    ];
    final variant = variants[_random.nextInt(variants.length)];

    return Obstacle(
      width: variant.width,
      height: variant.height,
      bodyColor: Color(variant.body),
      accentColor: Color(variant.accent),
    );
  }

  double _nextSpawnDelay() {
    return 1.35 + _random.nextDouble() * 0.95;
  }
}
