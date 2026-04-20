import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../config/game_config.dart';
import '../../game/clementine_game.dart';
import 'road_profile.dart';

class Ground extends PositionComponent with HasGameReference<ClementineGame> {
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

    final roadPath = Path();
    final topPath = Path();
    final topStartY = _surfaceYAt(-24);
    roadPath.moveTo(-24, size.y);
    roadPath.lineTo(-24, topStartY);
    topPath.moveTo(-24, topStartY);

    for (double x = -12; x <= size.x + 24; x += 12) {
      final y = _surfaceYAt(x);
      roadPath.lineTo(x, y);
      topPath.lineTo(x, y);
    }

    roadPath
      ..lineTo(size.x + 24, size.y)
      ..close();

    canvas.drawPath(roadPath, asphaltPaint);
    canvas.drawPath(
      topPath,
      Paint()
        ..color = shoulderPaint.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawPath(
      topPath,
      Paint()
        ..color = curbPaint.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawPath(
      topPath,
      Paint()
        ..color = glowPaint.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round,
    );

    for (var x = -_laneOffset; x < size.x + 48; x += 72) {
      final laneY = _surfaceYAt(x + 20) + 28;
      final slope = RoadProfile.slopeAngleAtWorldX(game.scrollDistance + x + 20);
      canvas.save();
      canvas.translate(x + 20, laneY);
      canvas.rotate(slope);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset.zero, width: 40, height: 6),
          const Radius.circular(3),
        ),
        lanePaint,
      );
      canvas.restore();
    }

    canvas.drawRect(Rect.fromLTWH(0, size.y - 14, size.x, 14), shoulderPaint);
  }

  double _surfaceYAt(double x) {
    return RoadProfile.surfaceYAtScreenX(
          scrollDistance: game.scrollDistance,
          screenX: x,
        ) - position.y;
  }
}
