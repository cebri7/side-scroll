import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../config/game_config.dart';

class Ground extends PositionComponent {
  Ground()
      : super(
          priority: 0,
          position: Vector2(0, GameConfig.gameHeight - GameConfig.groundHeight),
          size: Vector2(GameConfig.gameWidth, GameConfig.groundHeight),
        );

  double _laneOffset = 0;

  @override
  void update(double dt) {
    super.update(dt);
    _laneOffset = (_laneOffset + 120 * dt) % 72;
  }

  @override
  void render(Canvas canvas) {
    final asphaltPaint = Paint()..color = const Color(0xFF111827);
    final curbPaint = Paint()..color = const Color(0xFF1F2937);
    final lanePaint = Paint()..color = const Color(0xFFE5E7EB);
    final shoulderPaint = Paint()..color = const Color(0xFF0B1220);
    final glowPaint = Paint()..color = const Color(0x4438BDF8);

    canvas.drawRect(size.toRect(), asphaltPaint);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, 10), shoulderPaint);
    canvas.drawRect(Rect.fromLTWH(0, 10, size.x, 8), curbPaint);
    canvas.drawRect(Rect.fromLTWH(0, 22, size.x, 2), glowPaint);

    for (var x = -_laneOffset; x < size.x + 48; x += 72) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, 34, 40, 6),
          const Radius.circular(3),
        ),
        lanePaint,
      );
    }

    canvas.drawRect(
      Rect.fromLTWH(0, size.y - 14, size.x, 14),
      shoulderPaint,
    );
  }
}
