import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../config/game_config.dart';

class TokyoParallax extends PositionComponent {
  TokyoParallax()
      : super(
          priority: -10,
          size: Vector2(GameConfig.gameWidth, GameConfig.gameHeight),
        );

  double _farScroll = 0;
  double _midScroll = 0;
  double _nearScroll = 0;

  @override
  void update(double dt) {
    super.update(dt);
    _farScroll += 10 * dt;
    _midScroll += 22 * dt;
    _nearScroll += 38 * dt;
  }

  @override
  void render(Canvas canvas) {
    final skyPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF08111F),
          Color(0xFF152544),
          Color(0xFF22375B),
        ],
      ).createShader(size.toRect());

    final moonPaint = Paint()..color = const Color(0xFFEBF4FF).withOpacity(0.9);
    final starPaint = Paint()..color = const Color(0xCCFFFFFF);
    final farPaint = Paint()..color = const Color(0xFF18263B);
    final midPaint = Paint()..color = const Color(0xFF223250);
    final nearPaint = Paint()..color = const Color(0xFF31456D);
    final windowPaint = Paint()..color = const Color(0x66FDE68A);
    final accentPaint = Paint()..color = const Color(0xCC38BDF8);
    final railPaint = Paint()..color = const Color(0xFF0F172A);

    canvas.drawRect(size.toRect(), skyPaint);
    canvas.drawCircle(const Offset(520, 72), 26, moonPaint);

    for (final star in _stars) {
      canvas.drawCircle(Offset(star.dx, star.dy), star.dz, starPaint);
    }

    _drawBuildings(
      canvas,
      paint: farPaint,
      windowPaint: windowPaint,
      baseline: 170,
      width: 28,
      heightStep: 14,
      scroll: _farScroll,
      accentEvery: 7,
      accentPaint: accentPaint,
    );
    _drawBuildings(
      canvas,
      paint: midPaint,
      windowPaint: windowPaint,
      baseline: 224,
      width: 36,
      heightStep: 18,
      scroll: _midScroll,
      accentEvery: 5,
      accentPaint: accentPaint,
    );
    _drawBuildings(
      canvas,
      paint: nearPaint,
      windowPaint: windowPaint,
      baseline: 276,
      width: 48,
      heightStep: 24,
      scroll: _nearScroll,
      accentEvery: 4,
      accentPaint: accentPaint,
    );

    canvas.drawRect(
      Rect.fromLTWH(0, 288, size.x, 6),
      railPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(0, 298, size.x, 3),
      accentPaint..color = const Color(0xAA7DD3FC),
    );
  }

  void _drawBuildings(
    Canvas canvas, {
    required Paint paint,
    required Paint windowPaint,
    required Paint accentPaint,
    required double baseline,
    required double width,
    required double heightStep,
    required double scroll,
    required int accentEvery,
  }) {
    final localOffset = scroll % width;
    final startIndex = (scroll / width).floor() - 1;
    var x = -localOffset - width;
    var index = startIndex;

    while (x < size.x + width) {
      final heightTier = _positiveModulo(index, 5);
      final height = 36 + heightTier * heightStep;
      final rect = Rect.fromLTWH(x, baseline - height, width - 3, height);
      canvas.drawRect(rect, paint);

      if (_positiveModulo(index, accentEvery) == 0) {
        canvas.drawRect(
          Rect.fromLTWH(x + (width * 0.5) - 2, baseline - height - 18, 4, 18),
          accentPaint,
        );
      }

      final windowRows = (height / 18).floor();
      for (var row = 0; row < windowRows; row++) {
        final windowY = baseline - height + 8 + row * 14;
        canvas.drawRect(
          Rect.fromLTWH(x + 6, windowY, 4, 6),
          windowPaint,
        );
        if (width > 28) {
          canvas.drawRect(
            Rect.fromLTWH(x + width - 14, windowY, 4, 6),
            windowPaint,
          );
        }
      }

      x += width;
      index += 1;
    }
  }

  int _positiveModulo(int value, int divisor) {
    return ((value % divisor) + divisor) % divisor;
  }
}

const _stars = <({double dx, double dy, double dz})>[
  (dx: 54, dy: 40, dz: 1.2),
  (dx: 108, dy: 82, dz: 1.6),
  (dx: 166, dy: 58, dz: 1.1),
  (dx: 226, dy: 34, dz: 1.3),
  (dx: 292, dy: 74, dz: 1.4),
  (dx: 346, dy: 50, dz: 1.2),
  (dx: 412, dy: 88, dz: 1.7),
  (dx: 468, dy: 44, dz: 1.0),
  (dx: 586, dy: 90, dz: 1.5),
];
