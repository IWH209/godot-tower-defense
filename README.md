# Godot Tower Defense Game

This repository contains the starting point for a 2D tower‑defense game built with **Godot 4**.  The game is designed for PC and Steam Deck with a native resolution of **1280 × 800**.  The core gameplay loop consists of placing towers, starting enemy waves, earning coins and defending your base.

## Project layout

The project is organized into several top‑level folders:

- **autoload/** – Global singleton scripts.  These handle global state, currency and wave management.
- **scripts/** – Individual scripts for towers, bullets, enemies and placement logic.  Each script is designed to be attached to the appropriate scene node inside Godot.
- **scenes/** – Scene files will live here when you create them in the editor.  The repository does not include `.tscn` files; they can be created later in Godot using these scripts.

## How to use this repository

1. **Clone** the repository or download it as a ZIP and extract it.
2. **Open Godot 4** and choose *Import* > *Browse* to select this folder.  When asked, **create a new `project.godot` file**.  In Project Settings set:
   - Window size to **1280 × 800**.
   - Stretch mode to `canvas` with aspect `keep` (for pixel art).
   - Add the following input actions in the *Input Map*: `place_tower`, `pause`, `ui_accept`, `ui_cancel`.
3. In the **Autoload** tab, add the following scripts as singletons:
   - `autoload/Game.gd` (name it `Game`)
   - `autoload/Economy.gd` (name it `Economy`)
   - `autoload/WaveManager.gd` (name it `WaveManager`)
4. Create scenes for your level, towers and enemies and attach the scripts from the `scripts/` folder.  A simple level can include:
   - A `Path2D` with a `PathFollow2D` for enemies to follow.
   - A `TileMap` for the ground.
   - A `YSort` node for proper z‑ordering of towers and enemies.
5. Use the `WaveManager` to define your waves in the level script.  See the comments in the script for details.

## Scripts included

The repository includes the following GDScript files:

- **autoload/Game.gd** – Manages pause state and exposes a random number generator.
- **autoload/Economy.gd** – Handles coins, lives and base damage.
- **autoload/WaveManager.gd** – Spawns enemies, tracks waves and signals when waves start and end.
- **scripts/Enemy.gd** – Controls enemy movement along a `PathFollow2D` and handles damage.
- **scripts/Tower.gd** – Handles tower targeting and firing bullets at enemies.
- **scripts/Bullet.gd** – Moves towards a target and applies damage on impact.
- **scripts/PlacementController.gd** – Allows placing towers on the map when the player presses the `place_tower` action.

## Next steps

This is just a **vertical slice** starter.  From here you can add more towers, enemies, UI, audio, effects and eventually integrate Steam features (achievements, cloud saves).  Remember to test early on the Steam Deck to ensure performance and text legibility.
