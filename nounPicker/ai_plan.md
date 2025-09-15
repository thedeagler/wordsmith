# Noun Picker UI Implementation Plan

## Overview
Create a simple UI system that presents adjectives one at a time and allows the player to choose which noun (body, feet, or hand) should be modified with that adjective.

## Core Components

### 1. NounPickerScene.tscn
- **CanvasLayer** (root)
  - **VBoxContainer** (main container, centered)
    - **Label** (title) - "Which should be made [adjective]?"
    - **HBoxContainer** (button container)
      - **Button** (body) - "Body: [noun.body.name]"
      - **Button** (feet) - "Feet: [noun.feet.name]" 
      - **Button** (hand) - "Hand: [noun.hand.name]"
    - **Label** (selection_display) - "[adjective] [noun]" (with rarity color)
    - **Button** (confirm) - "Confirm" (initially hidden)
    - **Label** (progress) - "Adjective X of Y"

### 2. NounPicker.gd
```gdscript
extends Control
class_name NounPicker

signal adjective_applied(adjective: AdjectiveData, target_property: String)
signal all_adjectives_processed

var adjectives_to_process: Array[AdjectiveData] = []
var current_adjective_index: int = 0
var current_adjective: AdjectiveData
var selected_property: String = ""
var selected_noun: NounData

func _ready():
    setup_ui()
    hide()

func setup_ui():
    # Connect button signals
    $VBoxContainer/HBoxContainer/BodyButton.pressed.connect(_on_body_selected)
    $VBoxContainer/HBoxContainer/FeetButton.pressed.connect(_on_feet_selected)
    $VBoxContainer/HBoxContainer/HandButton.pressed.connect(_on_hand_selected)
    $VBoxContainer/ConfirmButton.pressed.connect(_on_confirm_selected)

func start_picking(adjectives: Array[AdjectiveData]):
    adjectives_to_process = adjectives.duplicate()
    current_adjective_index = 0
    show()
    process_next_adjective()

func process_next_adjective():
    if current_adjective_index >= adjectives_to_process.size():
        all_adjectives_processed.emit()
        hide()
        return
    
    current_adjective = adjectives_to_process[current_adjective_index]
    selected_property = ""
    selected_noun = null
    update_ui()
    current_adjective_index += 1

func update_ui():
    # Update title with current adjective
    var title = "Which should be made %s?" % current_adjective.word
    $VBoxContainer/TitleLabel.text = title
    
    # Update button labels with noun names
    $VBoxContainer/HBoxContainer/BodyButton.text = "Body: %s" % PlayerData.noun.body.name
    $VBoxContainer/HBoxContainer/FeetButton.text = "Feet: %s" % PlayerData.noun.feet.name
    $VBoxContainer/HBoxContainer/HandButton.text = "Hand: %s" % PlayerData.noun.hand.name
    
    # Hide selection display and confirm button initially
    $VBoxContainer/SelectionDisplay.visible = false
    $VBoxContainer/ConfirmButton.visible = false
    
    # Update progress
    var progress = "Adjective %d of %d" % [current_adjective_index + 1, adjectives_to_process.size()]
    $VBoxContainer/ProgressLabel.text = progress

func _on_body_selected():
    select_property("body")

func _on_feet_selected():
    select_property("feet")

func _on_hand_selected():
    select_property("hand")

func select_property(property: String):
    selected_property = property
    selected_noun = PlayerData.noun.get(property)
    
    if selected_noun:
        # Show the adjective + noun combination with rarity color
        var combination_text = "%s %s" % [current_adjective.word, selected_noun.name]
        $VBoxContainer/SelectionDisplay.text = combination_text
        
        # Apply rarity color to the text
        var rarity_color = get_rarity_color(current_adjective.rarity)
        $VBoxContainer/SelectionDisplay.add_theme_color_override("font_color", rarity_color)
        
        # Show the selection and confirm button
        $VBoxContainer/SelectionDisplay.visible = true
        $VBoxContainer/ConfirmButton.visible = true

func _on_confirm_selected():
    if selected_property != "" and selected_noun:
        # Apply adjective to the selected noun property
        selected_noun.adjectives.append(current_adjective)
        adjective_applied.emit(current_adjective, selected_property)
    
    # Process next adjective
    process_next_adjective()

func get_rarity_color(rarity: RarityData) -> Color:
    if rarity:
        return rarity.color
    return Color.WHITE  # Default color if no rarity data
```

### 3. Integration with TownNPC.gd
Modify the dialog completion handler to trigger the noun picker:

```gdscript
func _on_dialog_completed(_dialog_box: DialogBox, canvas_layer: CanvasLayer):
    # Dialog finished, now show noun picker
    show_noun_picker()
    is_interacting = false
    # Clean up the dialog box and canvas layer
    if canvas_layer and is_instance_valid(canvas_layer):
        canvas_layer.queue_free()

func show_noun_picker():
    var noun_picker = preload("res://nounPicker/NounPicker.tscn").instantiate()
    var canvas_layer = CanvasLayer.new()
    canvas_layer.layer = 101 # Higher than dialog layer
    get_tree().current_scene.add_child(canvas_layer)
    canvas_layer.add_child(noun_picker)
    
    # Start picking with player's collected adjectives
    noun_picker.start_picking(PlayerData.adjInventory)
    
    # Connect to completion signal
    noun_picker.all_adjectives_processed.connect(_on_noun_picking_completed.bind(noun_picker, canvas_layer), CONNECT_ONE_SHOT)

func _on_noun_picking_completed(noun_picker: NounPicker, canvas_layer: CanvasLayer):
    # Clean up
    if canvas_layer and is_instance_valid(canvas_layer):
        canvas_layer.queue_free()
    
    # Clear the adjective inventory since they've been applied
    PlayerData.adjInventory.clear()
```

## File Structure
```
nounPicker/
├── NounPicker.tscn
├── NounPicker.gd
└── ai_plan.md
```

## Usage Flow
1. Player interacts with Wordsmith NPC
2. Dialog shows collected adjectives
3. Dialog completes, triggers noun picker
4. For each adjective:
   - Show "Which should be made [adjective]?" 
   - Player clicks body/feet/hand button
   - Adjective is applied to selected noun property
5. Repeat until all adjectives processed
6. Return to game

## Styling Notes
- Use simple, clear fonts
- Make buttons large and easy to click
- Use contrasting colors for better visibility
- Center everything on screen
- Add subtle animations for button presses

## Error Handling
- Check if noun properties exist before displaying
- Handle empty adjective lists gracefully
- Validate adjective data before processing
- Provide fallback text for missing noun names
