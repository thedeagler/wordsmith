class_name CSVProcessor
extends RefCounted

## CSV Processor for parsing adjective data
## Handles CSV parsing, validation, and data structure conversion

const VALID_RARITIES = ["common", "rare", "epic", "legendary"]

var _csv_data: Array[Dictionary] = []
var _errors: Array[String] = []
var _warnings: Array[String] = []

## Parse CSV file and return structured data
func parse_csv(file_path: String) -> Array[Dictionary]:
	_errors.clear()
	_warnings.clear()
	_csv_data.clear()
	
	if not FileAccess.file_exists(file_path):
		_errors.append("CSV file not found: " + file_path)
		return []
	
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		_errors.append("Failed to open CSV file: " + file_path)
		return []
	
	var line_number = 0
	var header_processed = false
	
	while not file.eof_reached():
		var line = file.get_line()
		line_number += 1
		
		# Skip empty lines
		if line.strip_edges().is_empty():
			continue
		
		# Skip header line
		if not header_processed:
			header_processed = true
			continue
		
		var row_data = _parse_csv_line(line)
		if not row_data.is_empty():
			var validation_result = _validate_row(row_data, line_number)
			if validation_result.valid:
				_csv_data.append(row_data)
			else:
				_errors.append_array(validation_result.errors)
				_warnings.append_array(validation_result.warnings)
	
	file.close()
	return _csv_data

## Parse a single CSV line into a dictionary
func _parse_csv_line(line: String) -> Dictionary:
	var parts = line.split(",")
	if parts.size() < 3:
		return {}
	
	var word = parts[0].strip_edges()
	var rarity = parts[1].strip_edges()
	var description = parts[2].strip_edges()
	
	# Remove quotes from description if present
	if description.begins_with("\"") and description.ends_with("\""):
		description = description.substr(1, description.length() - 2)
	
	return {
		"word": word,
		"rarity": rarity,
		"description": description
	}

## Validate a single row of data
func _validate_row(row_data: Dictionary, line_number: int) -> Dictionary:
	var result = {
		"valid": true,
		"errors": [],
		"warnings": []
	}
	
	# Check word
	if row_data.get("word", "").is_empty():
		result.valid = false
		result.errors.append("Line " + str(line_number) + ": Word cannot be empty")
	
	# Check rarity
	var rarity = row_data.get("rarity", "").to_lower()
	if rarity.is_empty():
		result.valid = false
		result.errors.append("Line " + str(line_number) + ": Rarity cannot be empty")
	elif rarity not in VALID_RARITIES:
		result.valid = false
		result.errors.append("Line " + str(line_number) + ": Invalid rarity '" + rarity + "'. Must be one of: " + str(VALID_RARITIES))
	
	# Check description
	var description = row_data.get("description", "")
	if description.is_empty():
		result.warnings.append("Line " + str(line_number) + ": Description is empty for word '" + row_data.get("word", "") + "'")
	
	# Check for duplicate words
	var word = row_data.get("word", "")
	for existing_row in _csv_data:
		if existing_row.get("word", "") == word:
			result.warnings.append("Line " + str(line_number) + ": Duplicate word '" + word + "' found")
			break
	
	return result

## Get validation errors
func get_errors() -> Array[String]:
	return _errors

## Get validation warnings
func get_warnings() -> Array[String]:
	return _warnings

## Check if processing was successful
func has_errors() -> bool:
	return not _errors.is_empty()

## Get summary of processing results
func get_summary() -> String:
	var summary = "CSV Processing Summary:\n"
	summary += "  Rows processed: " + str(_csv_data.size()) + "\n"
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
