# Character Creation Scene Implementation Plan

## Overview

Create a character creation scene where players input their character name and select three adjectives to create their character description. The process involves:

1. Name input prompt
2. Three rounds of adjective selection from randomized cards
3. Dynamic label showing current character description
4. Final animation combining all selections
5. Transition to game start

This scene will serve as the entry point to the game experience.

## 1. Scene Structure

### Files to Create:

```
levels/characterCreation/
├── CharacterCreation.gd          # Main scene script
├── CharacterCreation.tscn        # Main scene file
├── ui/
│   ├── NameInputPanel.gd        # UI panel for name input
│   ├── NameInputPanel.tscn      # UI panel scene
│   ├── AdjectiveCard.gd         # Individual adjective card script
│   ├── AdjectiveCard.tscn       # Individual adjective card scene
│   ├── CardSelectionPanel.gd    # Panel managing three cards
│   └── CardSelectionPanel.tscn  # Panel scene for card selection
├── data/
│   └── Adjective.gd             # Adjective data structure
├── animations/
│   ├── CharacterCreationAnimations.gd  # Animation controller
│   └── SpeechBubbleAnimationController.gd  # Controls background speech bubbles
└── background/
    └── EerieBackground.gd       # Background styling and effects
```

### Scene Hierarchy:

- **CharacterCreation** (Node2D)
  - **Background** (ColorRect) - Dark, eerie gradient background
  - **SpeechBubbleContainer** (Node2D) - Container for animated speech bubbles
    - **SpeechBubble1** (SpeechBubble) - Animated background speech bubble
    - **SpeechBubble2** (SpeechBubble) - Animated background speech bubble
    - **SpeechBubble3** (SpeechBubble) - Animated background speech bubble
    - **SpeechBubble4** (SpeechBubble) - Animated background speech bubble
    - **SpeechBubble5** (SpeechBubble) - Animated background speech bubble
    - **SpeechBubbleAnimationController** (Node) - Controls bubble animations
  - **UI** (CanvasLayer)
    - **NameInputPanel** (CenterContainer) - Initially visible
      - **VBoxContainer**
        - **Title** (Label) - "What is your name?" (dark theme styling)
        - **NameInput** (LineEdit) (dark theme styling)
        - **SubmitButton** (Button) (dark theme styling)
        - **ErrorLabel** (Label - initially hidden, red text)
    - **CharacterDescriptionLabel** (CenterContainer) - Initially hidden
      - **Label** - Dynamic text showing current description (dark theme styling)
    - **CardSelectionPanel** (CenterContainer) - Initially hidden
      - **HBoxContainer**
        - **AdjectiveCard1** (Button) (dark theme styling)
        - **AdjectiveCard2** (Button) (dark theme styling)
        - **AdjectiveCard3** (Button) (dark theme styling)
    - **AnimationPlayer** (AnimationPlayer) - For final transition

## 2. Core Components

### 2.1 CharacterCreation.gd

**Purpose:** Main scene controller managing the multi-step character creation flow
**Responsibilities:**

- Initialize the character creation UI and state
- Handle scene transitions between name input and adjective selection
- Validate character name input
- Manage adjective selection rounds (3 rounds)
- Update character description dynamically
- Save player data with selected adjectives
- Navigate to the next scene (intro level)

**Key Properties:**

- `current_step: int` - Tracks current step (0=name, 1-3=adjective rounds)
- `player_name: String` - Stored player name
- `selected_adjectives: Array[Adjective]` - Array of selected adjectives
- `available_adjectives: Array[Adjective]` - Pool of all available adjectives

**Key Methods:**

- `_ready()` - Initialize UI, load adjectives, and connect signals
- `_on_name_submitted(name: String)` - Validate name and transition to adjective selection
- `_validate_name(name: String) -> bool` - Check name requirements
- `_start_adjective_selection()` - Begin first round of adjective selection
- `_on_adjective_selected(adjective: Adjective)` - Handle adjective selection
- `_update_character_description()` - Update the dynamic description label
- `_load_adjectives()` - Load adjective pool from data source
- `_get_random_adjectives(count: int) -> Array[Adjective]` - Get random adjectives for cards
- `_on_all_adjectives_selected()` - Handle completion and start final animation
- `_save_player_data()` - Store complete player information
- `_transition_to_game()` - Change to intro scene after animation

### 2.2 NameInputPanel.gd

**Purpose:** UI panel controller for name input
**Responsibilities:**

- Handle input field interactions
- Provide visual feedback
- Emit signals for name submission

**Key Methods:**

- `_on_submit_button_pressed()` - Handle submit button
- `_on_name_input_text_submitted(new_text: String)` - Handle enter key
- `_on_name_input_text_changed(new_text: String)` - Real-time validation
- `show_error(message: String)` - Display validation errors
- `clear_error()` - Hide error messages
- `show_panel()` - Make panel visible
- `hide_panel()` - Hide panel

### 2.3 AdjectiveCard.gd

**Purpose:** Individual adjective card controller
**Responsibilities:**

- Display adjective information
- Handle card click interactions
- Provide visual feedback for selection
- Emit selection signals

**Key Properties:**

- `adjective_data: Adjective` - The adjective data for this card
- `is_selected: bool` - Whether this card is currently selected

**Key Methods:**

- `_ready()` - Initialize card appearance
- `_on_card_pressed()` - Handle card click
- `set_adjective(adjective: Adjective)` - Set the adjective data
- `set_selected(selected: bool)` - Update visual state
- `play_selection_animation()` - Animate card selection

### 2.4 CardSelectionPanel.gd

**Purpose:** Panel managing the three adjective cards
**Responsibilities:**

- Manage the three adjective cards
- Handle card selection logic
- Update card displays with new adjectives
- Emit signals for adjective selection

**Key Properties:**

- `card1: AdjectiveCard` - First adjective card
- `card2: AdjectiveCard` - Second adjective card
- `card3: AdjectiveCard` - Third adjective card

**Key Methods:**

- `_ready()` - Initialize cards and connect signals
- `populate_cards(adjectives: Array[Adjective])` - Set adjectives for all cards
- `_on_card_selected(adjective: Adjective)` - Handle card selection
- `show_panel()` - Make panel visible
- `hide_panel()` - Hide panel
- `reset_cards()` - Reset all cards to unselected state

### 2.5 Adjective.gd

**Purpose:** Data structure for adjective objects
**Responsibilities:**

- Store adjective name and metadata
- Provide serialization for save/load

**Key Properties:**

- `name: String` - The adjective text
- `id: String` - Unique identifier
- `category: String` - Adjective category (optional)

**Key Methods:**

- `to_dict() -> Dictionary` - Convert to dictionary for saving
- `from_dict(dict: Dictionary)` - Load from dictionary

### 2.6 globalState/PlayerData.gd

**Purpose:** Data structure for player information including adjectives
**Responsibilities:**

- Store player name, selected adjectives, and other character data
- Provide save/load functionality
- Initialize default values

**Key Properties:**

- `player_name: String`
- `selected_adjectives: Array[Adjective]` - The three selected adjectives
- `character_description: String` - Final combined description
- `created_date: String`
- `game_settings: Dictionary` (for future expansion)

**Key Methods:**

- `save_to_file()` - Save to JSON file
- `load_from_file()` - Load from JSON file
- `reset_to_defaults()` - Initialize with default values
- `generate_description() -> String` - Create final character description
- `add_adjective(adjective: Adjective)` - Add adjective to selection

### 2.7 SpeechBubbleAnimationController.gd

**Purpose:** Controls the animated background speech bubbles
**Responsibilities:**

- Manage multiple SpeechBubble instances
- Create fade in/out animations
- Randomize bubble positions and timing
- Maintain low transparency for background effect
- Cycle through incoherent text content

**Key Properties:**

- `speech_bubbles: Array[SpeechBubble]` - Array of bubble instances
- `animation_timer: Timer` - Controls animation timing
- `bubble_positions: Array[Vector2]` - Random positions for bubbles
- `incoherent_texts: Array[String]` - Array of mysterious text content

**Key Methods:**

- `_ready()` - Initialize bubbles and start animations
- `_on_animation_timer_timeout()` - Trigger bubble animations
- `animate_bubble(bubble: SpeechBubble)` - Animate individual bubble
- `get_random_position() -> Vector2` - Get random screen position
- `get_random_text() -> String` - Get random incoherent text

### 2.8 EerieBackground.gd

**Purpose:** Manages the dark, mysterious background styling
**Responsibilities:**

- Create dark gradient background
- Apply eerie color scheme
- Manage background effects and atmosphere
- Coordinate with speech bubble animations

**Key Properties:**

- `background_color: Color` - Primary background color
- `gradient_colors: Array[Color]` - Colors for gradient effect
- `atmosphere_intensity: float` - Controls mysterious effect intensity

**Key Methods:**

- `_ready()` - Initialize background styling
- `create_gradient_background()` - Set up gradient effect
- `apply_eerie_colors()` - Apply dark, mysterious color scheme

## 3. UI Design Specifications

### 3.1 Visual Style

- **Background:** Dark, eerie gradient background with mysterious atmosphere with whispy smoke effects
  - **Primary Colors:** Deep purples, dark blues, charcoal blacks
  - **Gradient:** Vertical gradient from dark purple (#2D1B3D) to deep black (#0A0A0A)
  - **Atmosphere:** Subtle misty overlay effect
- **Font:** Use the default font with eerie styling
- **Colors:** Dark theme with mysterious accent colors
  - **Text:** Light gray (#E8E8E8) for readability
  - **Accents:** Muted purple (#6B46C1) for highlights
  - **Cards:** Dark charcoal (#1A1A1A) with purple borders
- **Layout:** Centered, clean design with mysterious ambiance

### 3.2 Name Input Section

- **Title:** Large, centered text "What is your name?" (light gray, eerie styling)
- **Input Field:** LineEdit with dark theme styling
  - **Background:** Dark charcoal (#1A1A1A)
  - **Border:** Muted purple (#6B46C1)
  - **Text:** Light gray (#E8E8E8)
- **Validation:** Real-time character filtering
- **Length Limit:** 3-20 characters
- **Allowed Characters:** Letters, numbers, spaces, hyphens, underscores
- **Placeholder Text:** "Enter your character name..." (dimmed gray)

### 3.3 Character Description Label

- **Purpose:** Dynamic text showing current character description
- **Format Progression:**
  - Round 1: "You are... [player name]"
  - Round 2: "You are... [adjective1] [player name]"
  - Round 3: "You are... [adjective1] [adjective2] [player name]"
  - Round 4: "You are... [adjective1] [adjective2] [adjective3] [player name]"
- **Style:** Large, prominent text, centered
  - **Text Color:** Light gray (#E8E8E8)
  - **Background:** Semi-transparent dark overlay
  - **Font:** Slightly larger, mysterious styling
- **Animation:** Smooth text transitions when updating with subtle glow effect

### 3.4 Adjective Cards

- **Layout:** Three cards side by side in horizontal row
- **Card Design:**
  - Rectangular cards with rounded corners
  - **Background:** Dark charcoal (#1A1A1A) with purple border (#6B46C1)
  - **Text:** Light gray (#E8E8E8) for adjective names
  - **Hover Effects:** Subtle purple glow (#6B46C1) with increased opacity
  - **Selection Highlighting:** Bright purple border (#8B5CF6) with glow
  - **Adjective Text:** Centered on card with mysterious styling
- **Card Size:** Consistent, touch-friendly size
- **Spacing:** Even spacing between cards
- **Animation:** Card selection animations, slide-in effects for new cards with eerie transitions

### 3.5 Background Speech Bubbles

- **Purpose:** Create mysterious, incoherent background atmosphere
- **Quantity:** 5 SpeechBubble instances positioned randomly across screen
- **Content:** Incoherent, mysterious text snippets
  - Examples: "whispers...", "shadows...", "unknown...", "forgotten...", "echoes..."
- **Styling:**
  - **Transparency:** Very low opacity (0.15-0.25) to remain background
  - **Colors:** Muted purples and grays to blend with theme
  - **Size:** Varied sizes for visual interest
- **Animation:**
  - **Fade In/Out:** Continuous fade cycles with random timing
  - **Position Changes:** Occasional random repositioning
  - **Text Changes:** Cycle through different incoherent phrases
  - **Duration:** 3-5 second fade cycles with 1-2 second pauses

### 3.6 Error Handling

- **Error Label:** Red text below input field (name input only)
  - **Color:** Muted red (#DC2626) to fit dark theme
  - **Background:** Semi-transparent dark overlay
- **Common Errors:**
  - "Name must be 3-20 characters long"
  - "Name can only contain letters, numbers, and spaces"
  - "Please enter a name"

## 4. Character Creation Flow

### 4.1 Step-by-Step Process

1. **Name Input Phase:**

   - Display "What is your name?" prompt
   - Player enters name with validation
   - Submit button or Enter key proceeds

2. **Adjective Selection Phase (3 rounds):**

   - Round 1: Display 3 random adjectives, description shows "You are... [player name]"
   - Round 2: After selection, display 3 new adjectives, description updates to "You are... [adjective1] [player name]"
   - Round 3: After selection, display 3 final adjectives, description updates to "You are... [adjective1] [adjective2] [player name]"

3. **Completion Phase:**
   - After 3rd adjective selection, description shows final: "You are... [adjective1] [adjective2] [adjective3] [player name]"
   - Play combination animation
   - Transition to game start

### 4.2 Name Validation Rules

- **Minimum Length:** 1 character
- **Maximum Length:** 20 characters
- **Allowed Characters:** A-Z, a-z, 0-9, space, hyphen, underscore
- **Trimmed:** Remove leading/trailing whitespace
- **Unique Check:** Not required for initial implementation

### 4.3 Adjective Selection Rules

- **Randomization:** Each round shows 3 random adjectives from available pool
- **No Duplicates:** Selected adjectives are removed from future rounds
- **Selection Required:** Must select one adjective to proceed
- **Card Interaction:** Click any card to select that adjective

## 5. Data Persistence

### 5.1 Save Location

- **File Path:** `user://player_data.json`
- **Format:** JSON for easy reading and modification
- **Backup:** Consider auto-backup functionality

### 5.2 Data Structure

```json
{
  "player_name": "PlayerName",
  "selected_adjectives": [
    {
      "name": "Brave",
      "id": "brave_001",
      "category": "personality"
    },
    {
      "name": "Wise",
      "id": "wise_002",
      "category": "intelligence"
    },
    {
      "name": "Swift",
      "id": "swift_003",
      "category": "physical"
    }
  ],
  "character_description": "You are... the BRAVE, WISE, SWIFT PlayerName",
  "created_date": "2024-01-01T00:00:00Z",
  "game_settings": {
    "last_played": null,
    "preferences": {}
  }
}
```

## 6. Scene Flow Integration

### 6.1 Entry Point

- **Current:** main.gd redirects to intro scene
- **New:** main.gd checks for existing player data
  - If no data: redirect to character creation
  - If data exists: redirect to intro scene

### 6.2 Exit Point

- **Success:** Transition to intro scene (`res://levels/intro/Area1.tscn`)
- **Cancel:** Return to main menu (if implemented)

## 7. Input Handling

### 7.1 Keyboard Controls

- **Enter Key:** Submit name (if valid) or proceed to next step
- **Escape Key:** Clear input or show quit dialog (name input only)
- **Tab Key:** Focus management between UI elements (name input only)
- **Arrow Keys:** Navigate between adjective cards (optional)

### 7.2 Mouse Controls

- **Click Input Field:** Focus and select all text (name input only)
- **Click Submit Button:** Validate and submit name
- **Click Adjective Card:** Select that adjective and proceed
- **Click Background:** Deselect input field (name input only)

## 8. Error Handling & Edge Cases

### 8.1 File System Errors

- **Save Failure:** Show error message, allow retry
- **Corrupted Data:** Reset to defaults with warning
- **Permission Issues:** Fallback to temporary storage

### 8.2 Input Edge Cases

- **Empty Input:** Show validation error
- **Only Whitespace:** Trim and validate
- **Special Characters:** Filter and warn user
- **Very Long Names:** Truncate with notification

### 8.3 Adjective Selection Edge Cases

- **Insufficient Adjectives:** Handle case where adjective pool is smaller than needed
- **Card Selection Timing:** Prevent multiple rapid selections
- **Animation Interruption:** Handle user input during animations
- **Data Corruption:** Handle corrupted adjective data gracefully

## 9. Testing Considerations

### 9.1 Unit Tests

- Name validation functions
- Adjective data structure serialization
- Data save/load functionality
- Character description generation
- Adjective randomization logic

### 9.2 Integration Tests

- Complete character creation flow
- Scene transition between phases
- UI panel show/hide behavior
- Card selection and state management
- Final animation and game transition

### 9.3 User Testing

- Name input field usability
- Adjective card selection clarity
- Character description readability
- Overall flow intuitiveness
- Animation timing and feedback

## 10. Future Enhancements

### 10.1 Character Customization

- Avatar selection
- Color preferences
- Starting equipment

### 10.2 Settings Integration

- Audio preferences
- Graphics settings
- Control customization

### 10.3 Save System Expansion

- Multiple save slots
- Cloud save integration
- Export/import functionality

## 11. Implementation Priority

### Phase 1 (Core Functionality)

1. Create basic scene structure with all UI panels
2. Implement name input UI and validation
3. Create Adjective data structure and card system
4. Implement adjective selection logic (3 rounds)
5. Add dynamic character description updates
6. Create data persistence with adjective storage
7. Integrate with main scene flow
8. Implement dark, eerie background styling
9. Add SpeechBubble animation controller

### Phase 2 (Polish)

1. Add visual styling and card animations with dark theme
2. Implement error handling for all phases
3. Add keyboard shortcuts and accessibility
4. Create smooth transitions between phases
5. Add final combination animation
6. Implement background speech bubble animations
7. Fine-tune transparency and positioning for atmospheric effect
8. Add gradient background effects

### Phase 3 (Enhancements)

1. Add adjective categories and filtering
2. Implement character customization options
3. Add settings integration
4. Expand save system features
5. Add adjective unlock system
6. Enhanced atmospheric effects and particle systems
7. Dynamic background effects based on selected adjectives

## 12. Technical Dependencies

### 12.1 Existing Systems

- Main scene flow (main.gd)
- Input mapping system
- Font assets (Alien Font-Regular.otf)
- Scene transition system

### 12.2 New Dependencies

- JSON file handling for adjective data and player data
- UI signal system for card interactions
- Input validation utilities
- Data persistence layer with adjective support
- Animation system for card transitions and final combination
- Random number generation for adjective selection
- SpeechBubble system for background atmosphere
- Gradient background rendering system
- Fade in/out animation system for speech bubbles

---

This implementation plan provides a comprehensive roadmap for building the character creation feature. The modular approach allows for iterative development and easy testing of individual components.
