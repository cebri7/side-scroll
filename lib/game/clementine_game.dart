import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';

import '../config/game_config.dart';
import '../overlays/game_over_overlay.dart';
import '../overlays/hud_overlay.dart';
import '../overlays/main_menu_overlay.dart';
import '../overlays/pause_overlay.dart';
import '../systems/game_state.dart';
import 'clementine_world.dart';

class ClementineGame extends FlameGame<ClementineWorld>
  with ChangeNotifier, HasCollisionDetection, TapCallbacks {
  ClementineGame()
      : super(
          world: ClementineWorld(),
          camera: CameraComponent.withFixedResolution(
            width: GameConfig.gameWidth,
            height: GameConfig.gameHeight,
          ),
        );

  GameState gameState = GameState.menu;
  double distance = 0;
  double scrollSpeed = GameConfig.baseScrollSpeed;
  double scrollDistance = 0;

  @override
  Color backgroundColor() => const Color(0xFF08111F);

  @override
  Future<void> onLoad() async {
    camera.viewfinder.anchor = Anchor.topLeft;
    await super.onLoad();
    _showMenu();
  }

  @override
  void update(double dt) {
    if (gameState == GameState.playing) {
      scrollSpeed = (scrollSpeed + GameConfig.speedRampPerSecond * dt)
          .clamp(GameConfig.baseScrollSpeed, GameConfig.maxScrollSpeed);
      scrollDistance += scrollSpeed * dt;
      distance += scrollSpeed * dt * 0.1;
      notifyListeners();
    }
    super.update(dt);
  }

  void startGame() {
    distance = 0;
    scrollSpeed = GameConfig.baseScrollSpeed;
    scrollDistance = 0;
    gameState = GameState.playing;
    world.resetRun();
    overlays
      ..remove(MainMenuOverlay.id)
      ..remove(PauseOverlay.id)
      ..remove(GameOverOverlay.id)
      ..add(HudOverlay.id);
    resumeEngine();
    notifyListeners();
  }

  void pauseGame() {
    if (gameState != GameState.playing) {
      return;
    }
    gameState = GameState.paused;
    overlays.add(PauseOverlay.id);
    pauseEngine();
    notifyListeners();
  }

  void resumeGame() {
    if (gameState != GameState.paused) {
      return;
    }
    gameState = GameState.playing;
    overlays.remove(PauseOverlay.id);
    resumeEngine();
    notifyListeners();
  }

  void endGame() {
    gameState = GameState.gameOver;
    overlays
      ..remove(HudOverlay.id)
      ..remove(PauseOverlay.id)
      ..add(GameOverOverlay.id);
    pauseEngine();
    notifyListeners();
  }

  void returnToMenu() {
    _showMenu();
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (gameState == GameState.playing) {
      world.player.jump();
    }
    super.onTapDown(event);
  }

  void _showMenu() {
    gameState = GameState.menu;
    overlays
      ..remove(HudOverlay.id)
      ..remove(PauseOverlay.id)
      ..remove(GameOverOverlay.id)
      ..add(MainMenuOverlay.id);
    pauseEngine();
    notifyListeners();
  }

  @override
  void onRemove() {
    dispose();
    super.onRemove();
  }
}
