import 'package:flutter/material.dart';

import '../game/clementine_game.dart';

class MainMenuOverlay extends StatelessWidget {
  const MainMenuOverlay({
    required this.game,
    super.key,
  });

  static const id = 'main-menu';

  final ClementineGame game;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0x8808111F),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Card(
            color: const Color(0xFF101B2D),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Clementine Game',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Tokyo bike runner prototype',
                    style: TextStyle(color: Color(0xFFBFDBFE)),
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: game.startGame,
                    child: const Text('Start Run'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
