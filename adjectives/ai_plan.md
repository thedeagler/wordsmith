# CSV to Resource Importer Plan

## Overview
Create a build-time tool to convert the existing `adjectives.csv` into individual Godot Resource files (.tres) for better performance and type safety.

## Goal
Generate individual `.tres` resource files from CSV data at build time, maintaining the existing CSV as the source of truth.

## Implementation Plan

1. **Create CSVProcessor.gd**
   - Parse CSV file into structured data
   - Handle simple string data (word, rarity)
   - Validate data integrity
   - Handle missing or malformed data

2. **Create ResourceGenerator.gd**
   - Convert parsed CSV data to AdjectiveData resources
   - Generate individual .tres files
   - Create organized directory structure
   - Handle file naming and organization

3. **Create ImporterTool.gd**
   - Main tool script that orchestrates the process
   - Command-line interface for build scripts
   - Error handling and logging
   - Progress reporting

4. **Build Script Integration**
   - Add to project build process
   - Ensure resources are generated before game runs
   - Handle incremental updates

## File Structure
```
adjectives/
├── ai_plan.md                    # This planning document
├── AdjectiveData.gd             # Enhanced resource class
├── adjectives.csv               # Source data (unchanged)
├── adjectives.csv.import        # Godot import settings
├── tools/                       # Build-time tools
│   ├── CSVProcessor.gd         # CSV parsing logic
│   ├── ResourceGenerator.gd    # Resource creation logic
│   └── ImporterTool.gd         # Main importer script
├── resources/                   # Generated resource files
│   ├── common/                 # Common rarity adjectives
│   ├── rare/                   # Rare rarity adjectives
│   ├── epic/                   # Epic rarity adjectives
│   └── legendary/              # Legendary rarity adjectives
```

## CSV Data Format
Keep the current simple CSV format:

```csv
adjective,rarity
Smooth,common
Gleaming,rare
Soul crushing,legendary
```

## Resource Generation Process

### 1. CSV Parsing
- Read CSV file line by line
- Parse each row into a dictionary
- Validate required fields (word, rarity)
- Skip empty or malformed rows

### 2. Data Validation
- Check word uniqueness
- Validate rarity values against known tiers (common, rare, epic, legendary)
- Ensure word is not empty

### 3. Resource Creation
- Create AdjectiveData instance for each valid row
- Set word and rarity properties from CSV data
- Validate resource before saving

### 4. File Organization
- Group resources by rarity in subdirectories
- Use consistent naming: `{word}.tres`
- Handle special characters in filenames
- Create directory structure if needed

## Usage Examples

### Command Line Usage
```bash
# Generate all resources
godot --headless --script tools/ImporterTool.gd

# Generate with specific options
godot --headless --script tools/ImporterTool.gd -- --input adjectives.csv --output resources/
```

### Programmatic Usage
```gdscript
# In a build script
var importer = ImporterTool.new()
importer.import_csv("adjectives.csv", "resources/")
```

## Error Handling
- **CSV Parsing Errors**: Log line numbers and continue processing
- **Validation Errors**: Log specific validation failures
- **File System Errors**: Handle permission issues, disk space
- **Resource Creation Errors**: Skip invalid entries, report issues

