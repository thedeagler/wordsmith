class_name ResourceGenerator
extends RefCounted

## Resource Generator for creating AdjectiveData .tres files
## Converts parsed CSV data into individual Godot resource files

var _generated_files: Array[String] = []
var _errors: Array[String] = []
var _warnings: Array[String] = []

## Generate resource files from CSV data
func generate_resources(csv_data: Array[Dictionary], output_dir: String) -> bool:
	_generated_files.clear()
	_errors.clear()
	_warnings.clear()
	
	if csv_data.is_empty():
		_errors.append("No CSV data provided for resource generation")
		return false
	
	# Ensure output directory exists
	if not DirAccess.dir_exists_absolute(output_dir):
		var dir = DirAccess.open("res://")
		if dir.make_dir_recursive(output_dir) != OK:
			_errors.append("Failed to create output directory: " + output_dir)
			return false
	
	# Group data by rarity
	var data_by_rarity = _group_by_rarity(csv_data)
	
	# Generate resources for each rarity
	for rarity in data_by_rarity.keys():
		var rarity_dir = output_dir.path_join(rarity)
		if not _ensure_rarity_directory(rarity_dir):
			continue
		
		var rarity_data = data_by_rarity[rarity]
		for row_data in rarity_data:
			if not _generate_single_resource(row_data, rarity_dir):
				continue
	
	return _errors.is_empty()

## Group CSV data by rarity
func _group_by_rarity(csv_data: Array[Dictionary]) -> Dictionary:
	var grouped = {}
	
	for row_data in csv_data:
		var rarity = row_data.get("rarity", "common").to_lower()
		if not grouped.has(rarity):
			grouped[rarity] = []
		grouped[rarity].append(row_data)
	
	return grouped

## Ensure rarity directory exists
func _ensure_rarity_directory(rarity_dir: String) -> bool:
	if DirAccess.dir_exists_absolute(rarity_dir):
		return true
	
	var dir = DirAccess.open("res://")
	if dir.make_dir_recursive(rarity_dir) != OK:
		_errors.append("Failed to create rarity directory: " + rarity_dir)
		return false
	
	return true

## Generate a single resource file
func _generate_single_resource(row_data: Dictionary, rarity_dir: String) -> bool:
	var word = row_data.get("word", "")
	var rarity = row_data.get("rarity", "common")
	
	if word.is_empty():
		_errors.append("Cannot generate resource for empty word")
		return false
	
	# Create AdjectiveData resource
	var adjective_data = AdjectiveData.new(word, rarity)
	
	# Generate safe filename
	var safe_filename = _generate_safe_filename(word)
	var file_path = rarity_dir.path_join(safe_filename + ".tres")
	
	# Save resource
	var result = ResourceSaver.save(adjective_data, file_path)
	if result != OK:
		_errors.append("Failed to save resource for '" + word + "': " + str(result))
		return false
	
	_generated_files.append(file_path)
	return true

## Generate a safe filename from word
func _generate_safe_filename(word: String) -> String:
	# Replace problematic characters with underscores
	var safe_name = word
	safe_name = safe_name.replace(" ", "_")
	safe_name = safe_name.replace("-", "_")
	safe_name = safe_name.replace("'", "")
	safe_name = safe_name.replace("\"", "")
	safe_name = safe_name.replace("/", "_")
	safe_name = safe_name.replace("\\", "_")
	safe_name = safe_name.replace(":", "_")
	safe_name = safe_name.replace("*", "_")
	safe_name = safe_name.replace("?", "_")
	safe_name = safe_name.replace("<", "_")
	safe_name = safe_name.replace(">", "_")
	safe_name = safe_name.replace("|", "_")
	
	# Ensure it starts with a letter or underscore
	if safe_name.length() > 0 and not (safe_name[0].is_valid_identifier() or safe_name[0] == "_"):
		safe_name = "_" + safe_name
	
	# Limit length to reasonable size
	if safe_name.length() > 50:
		safe_name = safe_name.substr(0, 50)
	
	return safe_name

## Get list of generated files
func get_generated_files() -> Array[String]:
	return _generated_files

## Get generation errors
func get_errors() -> Array[String]:
	return _errors

## Get generation warnings
func get_warnings() -> Array[String]:
	return _warnings

## Check if generation was successful
func has_errors() -> bool:
	return not _errors.is_empty()

## Get summary of generation results
func get_summary() -> String:
	var summary = "Resource Generation Summary:\n"
	summary += "  Files generated: " + str(_generated_files.size()) + "\n"
	summary += "  Errors: " + str(_errors.size()) + "\n"
	summary += "  Warnings: " + str(_warnings.size()) + "\n"
	
	if not _errors.is_empty():
		summary += "\nErrors:\n"
		for error in _errors:
			summary += "  - " + error + "\n"
	
	if not _warnings.is_empty():
		summary += "\nWarnings:\n"
		for warning in _warnings:
			summary += "  - " + warning + "\n"
	
	return summary
