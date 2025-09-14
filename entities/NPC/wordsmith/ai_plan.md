# Bare-Bones Town NPC Implementation Plan

## Core Concept
A simple town NPC that:
1. **Dialogue**: Uses existing `SpeechBubble` system
2. **Adjective Adding**: Adds a random adjective to any item (not just weapons)
3. **Interaction**: Player approaches and presses a key

## Minimal Implementation

### 1. TownNPC Class
**Essential Properties:**
```gdscript
@export var npc_name: String = "Enchanter"
@export var interaction_range: float = 100.0
var player_in_range: bool = false
var is_interacting: bool = false
```

**Core Methods:**
- `_on_player_entered()` - Player detection
- `_on_player_exited()` - Player leaves
- `_on_interact()` - Handle interaction key
- `add_adjective_to_item()` - Add random adjective to item

### 2. Scene Structure
```
TownNPC (Node2D)
├── Sprite2D (visual)
├── InteractionArea (Area2D)
│   └── CollisionShape2D
└── SpeechBubble (existing component)
```

### 3. Interaction Flow
1. Player approaches NPC
2. Player presses interact key
3. NPC says greeting
4. NPC adds random adjective to player's item
5. NPC says completion message
6. Return to idle

## Adjective Adding System

### Simple Logic:
```gdscript
func add_adjective_to_item():
    # Get random adjective from existing system
    var random_adjective = get_random_adjective()
    
    # Add to player's current item (whatever they have equipped)
    var player_item = get_player_current_item()
    if player_item:
        player_item.add_adjective(random_adjective)
        show_dialogue("I've enchanted your item with: " + random_adjective.word)
    else:
        show_dialogue("You don't have an item to enchant!")
```

### Item Integration:
- Works with any item that has an `add_adjective()` method
- No damage modification, no costs, no complexity
- Just adds the adjective to the item's adjective list

## Dialogue System

### Simple Dialogue States:
- `greeting` - "Hello! I can add magical properties to your items."
- `enchanting` - "Let me enchant your item..."
- `complete` - "Done! Your item now has magical properties."
- `no_item` - "You need an item to enchant."

### Dialogue Examples:
- **Greeting**: "Welcome! I can add magical properties to your items."
- **Enchanting**: "Adding enchantment... *sparkle*"
- **Complete**: "Your item is now enchanted with: [Adjective]"
- **No Item**: "You need to have an item equipped first."

## File Structure
```
entities/NPC/town_npc/
├── TownNPC.gd              # Main NPC script (simple)
└── TownNPC.tscn            # NPC scene
```

## Integration Points

### Player Integration:
- Add "interact" input action
- Access player's current item
- Call item's `add_adjective()` method

### Item System Integration:
- Any item needs `add_adjective(adjective: AdjectiveData)` method
- Item stores adjectives in an array
- No other modifications needed

## Minimal Code Example

### TownNPC.gd (Core Logic):
```gdscript
extends Node2D

@export var npc_name: String = "Enchanter"
@export var interaction_range: float = 100.0

var player_in_range: bool = false
var is_interacting: bool = false

func _ready():
    $InteractionArea.body_entered.connect(_on_player_entered)
    $InteractionArea.body_exited.connect(_on_player_exited)

func _input(event):
    if event.is_action_pressed("interact") and player_in_range and not is_interacting:
        interact_with_player()

func _on_player_entered(body):
    if body.is_in_group("player"):
        player_in_range = true

func _on_player_exited(body):
    if body.is_in_group("player"):
        player_in_range = false

func interact_with_player():
    is_interacting = true
    add_adjective_to_item()
    is_interacting = false

func add_adjective_to_item():
    var random_adjective = get_random_adjective()
    var player_item = get_player_current_item()
    
    if player_item and player_item.has_method("add_adjective"):
        player_item.add_adjective(random_adjective)
        $SpeechBubble.show_text("I've enchanted your item with: " + random_adjective.word)
    else:
        $SpeechBubble.show_text("You need an item to enchant!")

func get_random_adjective():
    # Use existing adjective system
    return Utils.get_random_adjective()

func get_player_current_item():
    # Get player's current item (weapon, etc.)
    var player = get_tree().get_first_node_in_group("player")
    return player.get_current_item()
```

## What This Achieves

1. **Minimal Complexity**: Just dialogue + adjective adding
2. **Reusable**: Works with any item that has `add_adjective()` method
3. **Existing Systems**: Uses your adjective and speech bubble systems
4. **No Costs**: Free adjective adding
5. **No Damage**: No stat modifications
6. **Simple**: Easy to understand and extend

## Item Requirements

Any item that wants to work with this NPC just needs:
```gdscript
@export var adjectives: Array[AdjectiveData] = []

func add_adjective(adjective: AdjectiveData):
    adjectives.append(adjective)
    # Optional: Update display name or visual effects
```

This is as bare-bones as it gets - just dialogue and adding adjectives to items, nothing more!
