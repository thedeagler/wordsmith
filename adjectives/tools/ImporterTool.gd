@tool
extends EditorScript

## Main CSV to Resource Importer Tool
## Orchestrates the conversion of CSV data to Godot resource files

var csv_processor
var resource_generator

func _run():
	print("=== CSV to Resource Importer ===")
	
	# Parse command line arguments
	var args = _parse_arguments()
	
	# Set default values
	var input_file = args.get("input", "res://adjectives/adjectives.csv")
	var output_dir = args.get("output", "res://adjectives/resources/")
	var verbose = args.get("verbose", false)
	
	print("Input file: " + input_file)
	print("Output directory: " + output_dir)
	print("Verbose mode: " + str(verbose))
	print()
	
	# Initialize components
	var csv_processor_script = load("res://adjectives/tools/CSVProcessor.gd")
	var resource_generator_script = load("res://adjectives/tools/ResourceGenerator.gd")
	csv_processor = csv_processor_script.new()
	resource_generator = resource_generator_script.new()
	
	# Process CSV
	print("Step 1: Parsing CSV file...")
	var csv_data = csv_processor.parse_csv(input_file)
	
	if csv_processor.has_errors():
		print("ERROR: CSV parsing failed!")
		print(csv_processor.get_summary())
		return
	
	print("✓ CSV parsed successfully")
	if verbose:
		print("  Rows processed: " + str(csv_data.size()))
	
	# Show warnings if any
	if not csv_processor.get_warnings().is_empty():
		print("Warnings during CSV parsing:")
		for warning in csv_processor.get_warnings():
			print("  - " + warning)
		print()
	
	# Generate resources
	print("Step 2: Generating resource files...")
	var success = resource_generator.generate_resources(csv_data, output_dir)
	
	if not success:
		print("ERROR: Resource generation failed!")
		print(resource_generator.get_summary())
		return
	
	print("✓ Resources generated successfully")
	if verbose:
		print("  Files created: " + str(resource_generator.get_generated_files().size()))
	
	# Show warnings if any
	if not resource_generator.get_warnings().is_empty():
		print("Warnings during resource generation:")
		for warning in resource_generator.get_warnings():
			print("  - " + warning)
		print()
	
	# Final summary
	print("=== Import Complete ===")
	print("Total files generated: " + str(resource_generator.get_generated_files().size()))
	
	if verbose:
		print("\nGenerated files:")
		for file_path in resource_generator.get_generated_files():
			print("  - " + file_path)

## Parse command line arguments
func _parse_arguments() -> Dictionary:
	var args = {}
	
	# Get command line arguments
	var cmd_args = OS.get_cmdline_args()
	
	for i in range(cmd_args.size()):
		var arg = cmd_args[i]
		
		if arg == "--input" and i + 1 < cmd_args.size():
			args["input"] = cmd_args[i + 1]
		elif arg == "--output" and i + 1 < cmd_args.size():
			args["output"] = cmd_args[i + 1]
		elif arg == "--verbose" or arg == "-v":
			args["verbose"] = true
		elif arg == "--help" or arg == "-h":
			_show_help()
			return {}
	
	return args

## Show help information
func _show_help():
	print("CSV to Resource Importer")
	print("Usage: godot --headless --script adjectives/tools/ImporterTool.gd [options]")
	print()
	print("Options:")
	print("  --input <file>     Input CSV file (default: res://adjectives/adjectives.csv)")
	print("  --output <dir>     Output directory (default: res://adjectives/resources/)")
	print("  --verbose, -v      Enable verbose output")
	print("  --help, -h         Show this help message")
	print()
	print("Examples:")
	print("  # Use defaults")
	print("  godot --headless --script adjectives/tools/ImporterTool.gd")
	print()
	print("  # Custom input/output")
	print("  godot --headless --script adjectives/tools/ImporterTool.gd -- --input my_adjectives.csv --output my_resources/")
	print()
	print("  # Verbose mode")
	print("  godot --headless --script adjectives/tools/ImporterTool.gd -- --verbose")

## Programmatic interface for importing CSV
func import_csv(input_file: String, output_dir: String) -> bool:
	print("Importing CSV: " + input_file + " -> " + output_dir)
	
	# Initialize components
	var csv_processor_script = load("res://adjectives/tools/CSVProcessor.gd")
	var resource_generator_script = load("res://adjectives/tools/ResourceGenerator.gd")
	csv_processor = csv_processor_script.new()
	resource_generator = resource_generator_script.new()
	
	# Process CSV
	var csv_data = csv_processor.parse_csv(input_file)
	if csv_processor.has_errors():
		print("CSV parsing failed: " + str(csv_processor.get_errors()))
		return false
	
	# Generate resources
	var success = resource_generator.generate_resources(csv_data, output_dir)
	if not success:
		print("Resource generation failed: " + str(resource_generator.get_errors()))
		return false
	
	print("Import completed successfully")
	return true
