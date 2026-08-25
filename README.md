# Game-Loops-Breakout

A simple Breakout clone built with [Lua](https://www.lua.org/) and the [LÖVE](https://love2d.org/) framework, made to practice the fundamentals of a game loop: update, collision detection, and rendering.

## Demo

![Gameplay demo](docs/demo.gif)

*Add a GIF of the game running here, e.g. `docs/demo.gif`.*

## Gameplay

- Move the paddle left and right to bounce the ball.
- Break all the bricks to win.
- The ball speeds up slightly every time it hits the paddle.
- Let the ball fall past the paddle and it's game over.

## Controls

| Key | Action |
| --- | --- |
| ← | Move paddle left |
| → | Move paddle right |

## Requirements

- [LÖVE](https://love2d.org/) 11.x or later

## Running the game

```bash
love .
```

Run this command from the project root (the folder containing `main.lua`).

## How it works

The game state lives in three tables — `paddle`, `ball`, and `bricks` — set up in `love.load()`. Each frame:

- `love.update(dt)` moves the paddle and ball, checks wall bounds, and resolves collisions using a simple AABB (axis-aligned bounding box) check (`checkCollision`). The ball's direction flips on collision with walls, the paddle, or a brick; hitting a brick removes it from the `bricks` table. The game ends (win or lose) via `love.event.quit()`.
- `love.draw()` renders the paddle, ball, and remaining bricks each frame, with bricks colored by row.

## Project structure

```
.
├── main.lua    # Game logic (load/update/draw)
├── LICENSE
└── README.md
```

## License

MIT — see [LICENSE](LICENSE) for details.
