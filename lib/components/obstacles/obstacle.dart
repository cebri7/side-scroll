import 'dart:math' as math;

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../config/game_config.dart';
import '../environment/road_profile.dart';
import '../../game/clementine_game.dart';

class Obstacle extends PositionComponent with HasGameReference<ClementineGame> {
  Obstacle({
    required double width,
    required double height,
    required this.bodyColor,
    required this.accentColor,
  }) : super(
          priority: 8,
          anchor: Anchor.bottomLeft,
          position: Vector2(
            GameConfig.gameWidth + width + 24,
            GameConfig.gameHeight - GameConfig.groundHeight + GameConfig.obstacleGroundInset,
          ),
          size: Vector2(width, height),
        );

  final Color bodyColor;
  final Color accentColor;

  final Paint _wheelPaint = Paint()..color = const Color(0xFF020617);
  late final Paint _bodyPaint = Paint()..color = bodyColor;
  late final Paint _accentPaint = Paint()..color = accentColor;
  final Paint _windowPaint = Paint()..color = const Color(0xFFDBEAFE);
  final Paint _shadowPaint = Paint()..color = const Color(0x44000000);

  @override
  Future<void> onLoad() async {
    await add(
      RectangleHitbox(
        position: Vector2(6, size.y * 0.24),
        size: Vector2(size.x - 14, size.y * 0.52),
      )..collisionType = CollisionType.passive,
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= game.scrollSpeed * dt;
    position.y = RoadProfile.surfaceYAtScreenX(
          scrollDistance: game.scrollDistance,
          screenX: position.x,
        ) +
        GameConfig.obstacleGroundInset;
    if (position.x + size.x < -32) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    final wheelRadius = math.min(10.0, size.y * 0.18);
    final baseY = size.y - wheelRadius;
    final bodyTop = size.y * 0.26;
    final bodyHeight = size.y * 0.42;
    final cabinWidth = size.x * 0.34;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(4, size.y - 10, size.x - 8, 8),
        const Radius.circular(4),
      ),
      _shadowPaint,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(2, bodyTop + 6, size.x - 4, bodyHeight),
        const Radius.circular(10),
      ),
      _bodyPaint,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.x - cabinWidth - 10, bodyTop - 8, cabinWidth, bodyHeight * 0.72),
        const Radius.circular(10),
      ),
      _accentPaint,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.x - cabinWidth - 4, bodyTop - 4, cabinWidth * 0.58, bodyHeight * 0.38),
        const Radius.circular(6),
      ),
      _windowPaint,
    );

    canvas.drawRect(
      Rect.fromLTWH(size.x * 0.18, bodyTop + 18, size.x * 0.24, 4),
      _accentPaint,
    );

    canvas.drawCircle(Offset(size.x * 0.28, baseY), wheelRadius, _wheelPaint);
    canvas.drawCircle(Offset(size.x * 0.74, baseY), wheelRadius, _wheelPaint);
  }
}
