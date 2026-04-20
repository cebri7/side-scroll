import 'package:flutter/material.dart';

import '../game/clementine_game.dart';

class HudOverlay extends StatelessWidget {
  const HudOverlay({
    required this.game,
    super.key,
  });

  static const id = 'hud';

  final ClementineGame game;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0x99101B2D),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ListenableBuilder(
                  listenable: game,
                  builder: (context, _) {
                    return Text(
                      'Distance ${game.distance.floor()}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  },
                ),
              ),
            ),
            const Spacer(),
            IconButton.filledTonal(
              onPressed: game.pauseGame,
              icon: const Icon(Icons.pause),
            ),
          ],
        ),
      ),
    );
  }
}
