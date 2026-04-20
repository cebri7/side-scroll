import 'dart:math' as math;

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../config/game_config.dart';
import '../obstacles/obstacle.dart';
import '../environment/road_profile.dart';
import '../../game/clementine_game.dart';
import '../../systems/game_state.dart';
import 'player_state.dart';

class Player extends PositionComponent
  with HasGameReference<ClementineGame>, CollisionCallbacks {
  static const double _roadContactScreenOffsetX = 45;
  static const double _roadContactAnchorOffsetY = 6;

  Player()
      : super(
          priority: 10,
          anchor: Anchor.bottomLeft,
          position: Vector2(
            GameConfig.playerX,
            GameConfig.gameHeight - GameConfig.groundHeight + GameConfig.playerGroundInset,
          ),
          size: Vector2(96, 74),
        );

  final Paint _wheelPaint = Paint()..color = const Color(0xFF0F172A);
  final Paint _rimPaint = Paint()
    ..color = const Color(0xFFE2E8F0)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;
  final Paint _framePaint = Paint()
    ..color = const Color(0xFF38BDF8)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 4
    ..strokeCap = StrokeCap.round;
  final Paint _seatPaint = Paint()
    ..color = const Color(0xFFF97316)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 4
    ..strokeCap = StrokeCap.round;
  final Paint _bodyPaint = Paint()..color = const Color(0xFFF59E0B);
  final Paint _shirtPaint = Paint()..color = const Color(0xFFFB7185);
  final Paint _legPaint = Paint()
    ..color = const Color(0xFFF8FAFC)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 4
    ..strokeCap = StrokeCap.round;
  final Paint _hairPaint = Paint()..color = const Color(0xFF1E293B);

  PlayerState state = PlayerState.idle;
  double _wheelRotation = 0;
  double _pedalTime = 0;
  double _verticalVelocity = 0;
  bool _hasCrashed = false;

  @override
  Future<void> onLoad() async {
    await add(
      RectangleHitbox(
        position: Vector2(10, 14),
        size: Vector2(70, 44),
      )..collisionType = CollisionType.active,
    );
  }

  double get groundY =>
      RoadProfile.surfaceYAtScreenX(
        scrollDistance: game.scrollDistance,
        screenX: position.x + _roadContactScreenOffsetX,
        ) +
      _roadContactAnchorOffsetY;

  bool get isGrounded => position.y >= groundY - 0.5;

  @override
  void update(double dt) {
    super.update(dt);

    final groundedBeforeStep = isGrounded && _verticalVelocity == 0;

    if (groundedBeforeStep) {
      position.y = groundY;
    } else {
      _verticalVelocity += GameConfig.playerGravity * dt;
      position.y += _verticalVelocity * dt;

      if (position.y >= groundY) {
        position.y = groundY;
        _verticalVelocity = 0;
      }
    }

    if (_hasCrashed) {
      state = PlayerState.crashed;
    } else if (!isGrounded) {
      state = PlayerState.jumping;
    } else if (game.gameState == GameState.playing) {
      state = PlayerState.riding;
    } else {
      state = PlayerState.idle;
    }

    if (state == PlayerState.riding) {
      _wheelRotation += dt * (game.scrollSpeed / 36);
      _pedalTime += dt * (game.scrollSpeed / 90);
    } else if (state == PlayerState.jumping) {
      _wheelRotation += dt * (game.scrollSpeed / 54);
      _pedalTime += dt * 1.5;
    }
  }

  void jump() {
    if (!isGrounded) {
      return;
    }

    position.y = groundY - 0.1;
    _verticalVelocity = -GameConfig.playerJumpVelocity;
    state = PlayerState.jumping;
  }

  void reset() {
    _hasCrashed = false;
    position.y = groundY;
    _verticalVelocity = 0;
    _wheelRotation = 0;
    _pedalTime = 0;
    state = PlayerState.idle;
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (_hasCrashed || game.gameState != GameState.playing) {
      return;
    }

    if (other is Obstacle) {
      _hasCrashed = true;
      _verticalVelocity = 0;
      state = PlayerState.crashed;
      game.endGame();
    }
  }

  @override
  void render(Canvas canvas) {
    final rearWheel = Offset(20, 54);
    final frontWheel = Offset(70, 54);
    final crank = Offset(43, 42);
    final seat = Offset(35, 26);
    final handle = Offset(61, 24);
    final pedalSwing = math.sin(_pedalTime) * 7;
    final bodyBob = state == PlayerState.riding ? math.sin(_pedalTime * 2) * 1.5 : 0.0;
    final jumpLift = state == PlayerState.jumping ? -4.0 : 0.0;
    final torsoY = 13 + bodyBob + jumpLift;
    final roadSlope = RoadProfile.slopeAngleAtWorldX(game.scrollDistance + position.x + 34);
    final frameTilt = switch (state) {
      PlayerState.jumping => -0.14,
      PlayerState.crashed => 0.3,
      _ => roadSlope * 0.6,
    };

    canvas.save();
    canvas.translate(46, 38);
    canvas.rotate(frameTilt);
    canvas.translate(-46, -38);

    canvas.drawCircle(rearWheel, 14, _wheelPaint);
    canvas.drawCircle(frontWheel, 14, _wheelPaint);
    canvas.drawCircle(rearWheel, 10, _rimPaint);
    canvas.drawCircle(frontWheel, 10, _rimPaint);

    _drawSpokes(canvas, rearWheel);
    _drawSpokes(canvas, frontWheel);

    canvas.drawLine(rearWheel, crank, _framePaint);
    canvas.drawLine(crank, frontWheel, _framePaint);
    canvas.drawLine(seat, crank, _framePaint);
    canvas.drawLine(seat, frontWheel, _framePaint);
    canvas.drawLine(handle, frontWheel, _framePaint);
    canvas.drawLine(seat, const Offset(42, 22), _seatPaint);
    canvas.drawLine(handle, const Offset(67, 20), _seatPaint);

    canvas.drawCircle(Offset(49, torsoY - 2), 7, _bodyPaint);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(40, torsoY + 5, 16, 18),
        const Radius.circular(6),
      ),
      _shirtPaint,
    );
    canvas.drawArc(
      Rect.fromCircle(center: Offset(49, torsoY - 4), radius: 8),
      math.pi,
      math.pi,
      true,
      _hairPaint,
    );

    canvas.drawLine(Offset(48, torsoY + 10), seat, _legPaint);
    canvas.drawLine(Offset(52, torsoY + 10), handle, _legPaint);
    final crashLegOffset = state == PlayerState.crashed ? 8.0 : 0.0;
    canvas.drawLine(
      Offset(44, torsoY + 23),
      Offset(crank.dx - 3, crank.dy + pedalSwing + crashLegOffset),
      _legPaint,
    );
    canvas.drawLine(
      Offset(52, torsoY + 23),
      Offset(crank.dx + 10, crank.dy - pedalSwing + crashLegOffset),
      _legPaint,
    );

    canvas.restore();
  }

  void _drawSpokes(Canvas canvas, Offset center) {
    final spokePaint = Paint()
      ..color = const Color(0xFFCBD5E1)
      ..strokeWidth = 1.5;
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(_wheelRotation);
    canvas.drawLine(const Offset(-8, 0), const Offset(8, 0), spokePaint);
    canvas.drawLine(const Offset(0, -8), const Offset(0, 8), spokePaint);
    canvas.drawLine(const Offset(-6, -6), const Offset(6, 6), spokePaint);
    canvas.drawLine(const Offset(-6, 6), const Offset(6, -6), spokePaint);
    canvas.restore();
  }
}
