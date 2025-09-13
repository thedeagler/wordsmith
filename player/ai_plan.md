# Player Node Implementation Plan

## 1. Player File Structure
```
main/
├── Player.gd          # Main player script
├── Player.tscn        # Player scene
```
- **Player.gd** - Main player script attached to a CharacterBody2D node
- **Player.tscn** - Player scene with basic collision shape and sprite
- **InputMap configuration** - Customizable input actions in project settings

## 2. Basic Visual
1. Create CharacterBody2D node with collision shape
2. Add basic sprite/visual representation

## 3. Input System
- **Default Controls:**
  - W/A/S/D for movement (up/left/down/right)
  - No jump (not needed)
  - No mouse (not needed)
- **Configurable Input Actions:**
  - "move_left", "move_right", "move_up", "move_down"

## 4. Configuration System
- **Exported Variables:**
  - `movement_speed` (float, default: 200)
  - `acceleration` (float, default: 10)
  - `friction` (float, default: 10)
- **Input Configuration:**
  - Load input actions from InputMap

## 5. Movement System
- **Basic 2D Movement:**
  - Horizontal movement with acceleration/deceleration
  - Vertical movement (if jumping is implemented)
  - Movement speed as exported variable for easy tweaking
- **Physics:**
  - Use Godot's built-in CharacterBody2D physics
  - Handle collision detection
  - No gravity (not needed)

## 6. Test Scene
- Create a separate test scene (TestPlayer.tscn) with:
  - Player instance
  - Basic background/floor
  - Camera2D to follow player

