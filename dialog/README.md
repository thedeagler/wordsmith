# Dialog System

A simple dialog box system for displaying text conversations in the game.

## Files Created

- `DialogData.gd` - Resource class for storing dialog information
- `DialogBox.gd` - Main dialog controller script
- `DialogBox.tscn` - Dialog box scene with UI layout
- `DialogTest.gd` - Test script demonstrating usage
- `DialogTest.tscn` - Test scene for the dialog system

## Usage

### Basic Usage

```gdscript
# Load the dialog box scene
var dialog_box_scene = preload("res://dialog/DialogBox.tscn")
var dialog_box = dialog_box_scene.instantiate()
add_child(dialog_box)

# Create dialog data
var dialog_data = DialogData.new()
dialog_data.speaker_name = "Character Name"
dialog_data.dialog_texts = [
    "Hello there!",
    "This is a test dialog.",
    "Click continue to advance."
]

# Show the dialog
dialog_box.show_dialog(dialog_data)
```

### Signals

The DialogBox emits these signals:
- `dialog_completed` - Emitted when all dialog text has been shown
- `dialog_advanced` - Emitted when advancing to the next dialog text

### Testing

1. Open `DialogTest.tscn` in Godot
2. Run the scene to see the dialog system in action
3. Press space to test the dialog again

## Features

- Simple text display with RichTextLabel
- Continue button to advance through dialog
- Speaker name support
- Clean UI design using the game's font
- Easy integration with existing scenes
- No animations (as requested)
