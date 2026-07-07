# Snake AI – CS50 Final Project

## Overview

This project began as a classic implementation of **Snake**, built as the final project for Harvard's **CS50's Introduction to Game Development** course using **Lua** and the **LÖVE2D** framework. It follows the traditional rules of the game: guide the snake to eat food, grow longer with each bite, and avoid colliding with the walls or your own body.

The project was later extended beyond the course requirements with an **autonomous AI** capable of playing the game entirely on its own — no human input required. The AI is built around A* pathfinding, but layers several reliability checks on top of it so the snake avoids trapping itself as it grows, which is the central challenge of playing Snake well.This was done as a personal project after taking **CS50's Introduction to AI**.

## Features

- 🐍 Classic Snake gameplay (movement, growth, collisions, scoring)
- 🤖 Autonomous Snake AI that plays the game without human interaction
- 🧭 A* pathfinding as the core navigation algorithm
- ✅ Tail-reachability validation before committing to a food path
- 🔄 Board-state simulation of the snake's body after eating, before trusting that path
- 🐾 Tail-chasing fallback strategy when the food path is unsafe
- 🌊 Flood-fill reachable-space analysis to avoid enclosed regions
- 🛡️ Safe handling of cases where no valid path exists (no crashes)
- 🏆 Score tracking
- 🎮 Start menu and gameplay states

## AI Design

A* alone is not enough to play Snake reliably. A* is excellent at finding the *shortest* path to a target, but it has no concept of what happens *after* it arrives — a snake that always takes the shortest route to food will eventually corner itself with its own growing body, especially late in the game when the board is crowded. Reliability requires reasoning about the snake's future shape, not just the next destination.

To address this, the AI wraps A* in a decision pipeline rather than calling it once and blindly following the result:

1. **Food path (A*)** — the AI first computes the shortest A* path from the snake's head to the food. This remains the preferred move whenever it's safe.
2. **Simulation before commitment** — before accepting that path, the AI simulates what the snake's body would look like after following it and eating (including the new segment gained from growth).
3. **Tail-reachability check (A*)** — using that simulated board state, the AI runs a second A* search to confirm the new head could still reach the new tail. If it can, the region isn't sealed off, and the food path is accepted.
4. **Tail-chasing fallback (A*)** — if the food path would trap the snake, the AI instead searches for a path toward its own tail, effectively stalling in open space until a safer opportunity appears.
5. **Flood-fill as a last resort** — if neither A* search produces a usable path, the AI falls back to scoring its immediate legal moves using a flood-fill (BFS) reachable-space count, preferring the move that leaves the most open area rather than one that leads into a small pocket.
6. **Safe failure handling** — if no legal move exists at all, the AI fails gracefully instead of crashing, leaving the snake to run out its current direction rather than throwing an error.

These are **heuristic improvements**, not mathematical guarantees. They substantially reduce the frequency of self-trapping, but they do not formally prove the snake can never trap itself (that would require a fundamentally different approach, such as a Hamiltonian cycle strategy). The goal here was practical reliability built around A*, not theoretical completeness.

## Project Structure

```
Snake_Game/
├── main.lua                  # LÖVE2D entry point (love.load, love.update, love.draw)
├── src/
│   ├── Dependencies.lua       # Central require file for all game modules
│   ├── constants.lua          # Game-wide constants (board size, tile size, etc.)
│   ├── game_objects.lua       # Definitions for collectible/food objects
│   ├── AI.lua                 # A* search, simulation, flood-fill, and fallback decision logic
│   ├── Player.lua             # Snake state, movement, growth, and body-segment tracking
│   ├── PlayerParts.lua        # Individual body segment behavior
│   ├── GameObject.lua         # Generic game object base (used by food)
│   ├── StateMachine.lua       # Generic finite state machine
│   ├── Util.lua                # Helper/utility functions
│   ├── states/
│   │   ├── BaseState.lua       # Base class for all game states
│   │   └── game/
│   │       ├── StartState.lua     # Start menu / AI demo state
│   │       ├── PlayState.lua      # Main human-playable gameplay state
│   │       └── GameOverState.lua  # End-of-game state
│   └── world/
│       └── Board.lua           # Board generation, tile grid, food spawning
├── graphics/, fonts/, sounds/, drawnums/  # Game assets
└── lib/                        # Third-party LÖVE2D libraries
```

## Technologies Used

- **Lua** – core programming language
- **LÖVE2D** – 2D game framework used to build and render the game
- **A\* Search** – primary pathfinding algorithm for the AI
- **Flood-fill (BFS)** – reachable-space analysis used in the AI's fallback logic
- **Object-Oriented Programming** – class-based structure (`Player`, `Board`, `AI`, `GameObject`, states, etc.)
- **Git** – version control
- **GitHub** – project hosting and portfolio presentation

## Running the Project

1. **Install LÖVE2D** (version 11.x recommended):
   - Download it from [love2d.org](https://love2d.org/)
     
2. **Clone this repository:**
   ```bash
   git clone https://github.com/udeluca/Snake_Game.git
   cd "Snake - Final Project"
   ```
3. **Run the game:**
   ```bash
   love Snake_Game
   ```

## Local Version Control

Before this project was migrated to Git, development was tracked manually through a series of local project snapshots. As features were added, the project evolved through many local versions, and each significant milestone was preserved in its own dedicated version folder, kept in the `Previous_Versions/` directory.

These snapshots document the project's evolution step by step — from a bare-bones working Snake game through incremental gameplay refinements, early pathfinding experiments, and finally a fully autonomous A*-based AI. Keeping this history visible demonstrates the iterative, experimental nature of the development process before formal version control was introduced.

Git is now used going forward for proper source control, branching, and commit history.

## Development Timeline

- **Snake0 – Snake1.2:** Basic Snake implementation — grid movement, rendering, and collision detection.
- **Snake2 – Snake2.1:** Gameplay improvements — growth mechanics, scoring, and state management (start/play/game-over).
- **Snake3:** Initial A* implementation integrated into the game loop.
- **Snake_Final:** Final polishing, cleanup, and documentation.
- **Snake_With_AI** First working AI-driven snake using A* to food.
- **AI reliability improvements:** Added nil-path safety, food-path simulation, and tail-reachability validation to reduce self-trapping.
- **Flood-fill integration:** Added reachable-space scoring as a last-resort fallback when A* alone couldn't find a safe move.

## Screenshots


