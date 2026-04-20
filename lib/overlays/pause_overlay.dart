import 'package:flutter/material.dart';

import '../game/clementine_game.dart';

class PauseOverlay extends StatelessWidget {
  const PauseOverlay({
    required this.game,
    super.key,
  });

  static const id = 'pause';

  final ClementineGame game;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0x88000000),
      child: Center(
        child: Card(
          color: const Color(0xFF101B2D),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Paused',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: game.resumeGame,
                  child: const Text('Resume'),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: game.returnToMenu,
                  child: const Text('Back to Menu'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
