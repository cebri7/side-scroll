import 'package:flutter/material.dart';

import '../game/clementine_game.dart';

class GameOverOverlay extends StatelessWidget {
  const GameOverOverlay({
    required this.game,
    super.key,
  });

  static const id = 'game-over';

  final ClementineGame game;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xAA08111F),
      child: Center(
        child: Card(
          color: const Color(0xFF101B2D),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Game Over',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                ListenableBuilder(
                  listenable: game,
                  builder: (context, _) {
                    return Text(
                      'Distance ${game.distance.floor()}',
                      style: const TextStyle(color: Colors.white70),
                    );
                  },
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: game.startGame,
                  child: const Text('Restart'),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: game.returnToMenu,
                  child: const Text('Menu'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
