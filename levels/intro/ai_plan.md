# Basic Level Layout Plan - Two Area Introduction

## 1. Level Overview
- **Type**: Simple side-scrolling level with two areas
- **Purpose**: Basic level layout and scene transition testing
- **Transition**: Move from Area 1 to Area 2 via scene transition
- **No Enemies**: Focus on layout and camera following
- **Player**: ControllableCharacter2D for movement testing

## 2. Level Structure
```
Level Layout:
[Area 1] → [Scene Transition] → [Area 2]

- Area 1: Basic ground layout with some obstacles
- Scene Transition: Trigger when reaching right side of Area 1
- Area 2: Different ground layout, level ends here
```

## 3. Core Components

### 3.1 Area 1 Scene
- **File**: `levels/intro/Area1.gd` and `levels/intro/Area1.tscn`
- **Purpose**: First area with basic ground layout
- **Features**:
  - Different shades of dirt-brown tiles
  - Transition trigger on right side

### 3.2 Area 2 Scene
- **File**: `levels/intro/Area2.gd` and `levels/intro/Area2.tscn`
- **Purpose**: Second area with different layout
- **Features**:
  - Different shades of grassy green tiles
  - Level completion

### 3.3 Player Object
- **File**: `levels/intro/Player.gd` and `levels/intro/Player.tscn`
- **Purpose**: Controllable player for movement testing
- **Structure**:
  - Root Node: Player (Node2D)
  - Sub-node: ControllableCharacter2D (for movement)
  - Sub-node: Sprite2D (visual representation)
  - Sub-node: CollisionShape2D (collision detection)
- **Features**:
  - Uses existing ControllableCharacter2D for movement
  - Simple sprite representation
  - Collision detection with ground

### 3.4 Scene Transition
- **File**: `levels/intro/SceneTransition.gd`
- **Purpose**: Handle transition between Area 1 and Area 2
- **Features**:
  - Detect when player reaches transition point
  - Load Area 2 scene
  - Basic fade effect

## 4. Simple File Structure
```
levels/intro/
├── Area1.gd                   # Area 1 script
├── Area1.tscn                 # Area 1 scene
├── Area2.gd                   # Area 2 script
├── Area2.tscn                 # Area 2 scene
├── Player.gd                  # Player script
├── Player.tscn                # Player scene
└── SceneTransition.gd         # Transition handling
```

## 5. Camera Integration
- **Use**: Existing SmoothFollowCamera system
- **Target**: Player object (ControllableCharacter2D sub-node)
- **Bounds**: Each area has its own camera bounds
- **Transition**: Camera resets when transitioning between areas

## 6. Implementation Steps

### Step 1: Create Player Object
1. Create `Player.tscn` with ControllableCharacter2D as sub-node
2. Add Sprite2D and CollisionShape2D as sub-nodes
3. Create `Player.gd` script to handle player-specific logic
4. Test player movement

### Step 2: Create Area 1
1. Create `Area1.tscn` with basic ground layout
2. Add different shades of dirt-brown tiles
3. Add player instance to the scene
4. Set up camera bounds and target player
5. Add transition trigger on right side

### Step 3: Create Area 2
1. Create `Area2.tscn` with different ground layout
2. Add different shades of grassy green tiles
3. Add player instance to the scene
4. Set up camera bounds and target player
5. Add level completion

### Step 4: Scene Transition
1. Create `SceneTransition.gd` script
2. Detect when player reaches transition point in Area 1
3. Load Area 2 scene
4. Test transition works

## 7. Success Criteria
- ✅ Player object loads and is controllable
- ✅ Area 1 loads and displays correctly
- ✅ Camera follows player smoothly in Area 1
- ✅ Transition to Area 2 works
- ✅ Area 2 loads and displays correctly
- ✅ Camera follows player smoothly in Area 2
