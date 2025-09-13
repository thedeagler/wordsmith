extends Node
class_name Utils

static func random_symbol_string(length: int) -> String:
	# var symbols := "!@#$%^&*()_-+=[]{};:'\",.<>?/|\\~` "
	var symbols := "awejf;oaiewjfpap'o30-3 "
	var result := ""
	var rng := RandomNumberGenerator.new()
	rng.randomize()

	for i in length:
		var index := rng.randi_range(0, symbols.length() - 1)
		result += symbols[index]
	return result


static func load_adjectives(base_path: String = "res://adjectives/resources") -> void:
	var dir := DirAccess.open(base_path)

	if dir == null:
		push_error("Could not open directory: %s" % base_path)

	# List subdirectories (common, rare, epic, legendary)
	for subdir in dir.get_directories():
		var rarity_path := base_path.path_join(subdir)
		var rarity_resources: Array[Resource] = []

		var subdir_access := DirAccess.open(rarity_path)
		if subdir_access == null:
			continue

		# Collect all .tres files in this subdirectory
		for file in subdir_access.get_files():
			if file.ends_with(".tres"):
				var resource_path := rarity_path.path_join(file)
				var res = ResourceLoader.load(resource_path)
				if res != null:
					GameState.adjectives[res.rarity].append(res)

# TODO: set the weights as configurable arguments					
# TODO: add secret sauce tier	
static func get_random_rarity() -> String:
	var weights = {
		"common": 70,
		"rare": 20,
		"epic": 8,
		"legendary": 2
	}

	var roll = randi_range(1, 100) 
	var cumulative = 0

	for rarity in weights.keys():
		cumulative += weights[rarity]
		if roll <= cumulative:
			return rarity
	return "common"
	
static func get_random_adjective() -> AdjectiveData:
	var rarity = get_random_rarity()
	var random_index = randi_range(0, GameState.adjectives[rarity].size() - 1)
	var random_adjective = GameState.adjectives[rarity][random_index];
	return random_adjective
