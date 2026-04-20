import 'dart:math' as math;

import '../../config/game_config.dart';

abstract final class RoadProfile {
  static const double _primaryFrequency = 0.008;
  static const double _secondaryFrequency = 0.0034;
  static const double _primaryAmplitude = 18;
  static const double _secondaryAmplitude = 10;
  static const double _terrainFrequency = 0.00125;
  static const double _baseY = GameConfig.gameHeight - GameConfig.groundHeight;

  static double surfaceYAtWorldX(double worldX) {
    final hillEnvelope = _hillEnvelope(worldX);

    return _baseY +
        hillEnvelope *
            (_primaryAmplitude * math.sin(worldX * _primaryFrequency) +
                _secondaryAmplitude *
                    math.sin(worldX * _secondaryFrequency + 1.7));
  }

  static double surfaceYAtScreenX({
    required double scrollDistance,
    required double screenX,
  }) {
    return surfaceYAtWorldX(scrollDistance + screenX);
  }

  static double slopeAngleAtWorldX(double worldX) {
    const delta = 2.0;
    final left = surfaceYAtWorldX(worldX - delta);
    final right = surfaceYAtWorldX(worldX + delta);
    return (right - left) / (delta * 2);
  }

  static double _hillEnvelope(double worldX) {
    final terrainPhase = (math.sin(worldX * _terrainFrequency - 0.9) + 1) * 0.5;

    if (terrainPhase <= 0.36) {
      return 0;
    }

    final normalized = ((terrainPhase - 0.36) / 0.64).clamp(0.0, 1.0);
    return normalized * normalized * (3 - 2 * normalized);
  }
}
