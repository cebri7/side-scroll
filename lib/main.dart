import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'game/clementine_game.dart';
import 'overlays/game_over_overlay.dart';
import 'overlays/hud_overlay.dart';
import 'overlays/main_menu_overlay.dart';
import 'overlays/pause_overlay.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: GameWidget.controlled(
          gameFactory: ClementineGame.new,
          backgroundBuilder: (_) => const ColoredBox(
            color: Color(0xFF08111F),
          ),
          overlayBuilderMap: {
            MainMenuOverlay.id: (context, game) {
              return MainMenuOverlay(game: game as ClementineGame);
            },
            HudOverlay.id: (context, game) {
              return HudOverlay(game: game as ClementineGame);
            },
            PauseOverlay.id: (context, game) {
              return PauseOverlay(game: game as ClementineGame);
            },
            GameOverOverlay.id: (context, game) {
              return GameOverOverlay(game: game as ClementineGame);
            },
          },
        ),
      ),
    );
  }
}
