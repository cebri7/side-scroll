# Clementine Game Implementation Plan

## Game Concept
- Landscape side-scrolling endless runner
- Kid riding a bicycle through a Tokyo-themed neon cityscape
- Dodge obstacles with Alto-style smooth parallax scrolling
- Nighttime mood, minimalist prototype first

## Dependencies
- flame
- flame_audio

## Project Structure
```text
lib/
  main.dart
  game/
    clementine_game.dart
    clementine_world.dart
  components/
    player/
      player.dart
      player_state.dart
    obstacles/
      obstacle.dart
      obstacle_spawner.dart
      vehicle_obstacle.dart
    environment/
      ground.dart
      tokyo_parallax.dart
    effects/
      dodge_particles.dart
  systems/
    score_system.dart
    difficulty_system.dart
    game_state.dart
  overlays/
    main_menu_overlay.dart
    hud_overlay.dart
    game_over_overlay.dart
    pause_overlay.dart
  config/
    game_config.dart
  utils/
    audio_manager.dart
```

## Game Configuration
- Resolution: 640x360
- Viewport: FixedResolutionViewport
- Landscape orientation
- Player stays around 25 percent from left edge
- Base scroll speed ramps up over time

## Component Tree
- ClementineGame
- CameraComponent
- HUD components in viewport
- ClementineWorld
- TokyoParallax
- Ground
- Player
- ObstacleSpawner
- ScoreSystem
- DifficultySystem

## Game State Flow
- loading
- menu
- playing
- paused
- gameOver

## Player Mechanics
- Tap to jump
- Later add duck input
- Collision with obstacle ends run
- Near-miss bonus planned for later

## Scrolling Model
- World scrolls left
- Player remains mostly fixed on screen
- Background layers move at different parallax speeds
- Difficulty increases by raising scroll speed and spawn frequency

## Obstacle System
- Start with one simple vehicle obstacle
- Spawn off-screen right
- Move left with world speed
- Remove when off-screen
- Later expand obstacle variety

## Scoring
- Score based on distance traveled
- Later add near-miss bonuses and high score persistence

## Audio Plan
- One looping background track
- Jump or UI sound
- Crash sound
- Later add bicycle bell/horn and pause lifecycle handling

## Initial Asset Plan
- Warped City pack for background and placeholder city assets
- Placeholder player art first
- Placeholder obstacle art first
- Swap in final themed assets once loop is playable

## Implementation Phases
1. Add Flame dependencies and replace Flutter hello-world entrypoint
2. Create ClementineGame, ClementineWorld, config, and overlays
3. Add placeholder Tokyo-style parallax background
4. Add ground and placeholder bicycle rider component
5. Implement jump input and gravity
6. Add first obstacle component and spawner
7. Add collision detection and game over
8. Add distance scoring and speed ramp
9. Add menu, HUD, pause, and game over overlays
10. Add audio integration
11. Replace placeholders with real assets and polish effects
