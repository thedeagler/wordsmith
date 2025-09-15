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

		var subdir_access := DirAccess.open(rarity_path)
		if subdir_access == null:
			continue

		# Collect all .tres files in this subdirectory
		for file in subdir_access.get_files():
			if file.ends_with(".tres"):
				var resource_path := rarity_path.path_join(file)
				var res = ResourceLoader.load(resource_path)
				if res != null:
					GameState.adjectives[res.rarity.name].append(res)

# TODO: set the weights as configurable arguments					
# TODO: add secret sauce tier	
static func get_random_rarity() -> String:
	var weights = {
		"common": 70,
		"rare": 20,
		"epic": 7,
		"legendary": 3
	}

	var roll = randi_range(1, 100)
	var cumulative = 0

	for rarity in weights.keys():
		cumulative += weights[rarity]
		if roll <= cumulative:
			return rarity
	return "common"
	
static func get_random_part_of_speech() -> String:
	var weights = {
		"adj": 100,
		#"adj": 70,
		#"noun": 30,
	}

	var roll = randi_range(1, 100)
	var cumulative = 0

	for partOfSpeech in weights.keys():
		cumulative += weights[partOfSpeech]
		if roll <= cumulative:
			return partOfSpeech
	return "adj"
	
static func get_random_adjective() -> AdjectiveData:
	var rarity = get_random_rarity()
	var random_index = randi_range(0, GameState.adjectives[rarity].size() - 1)
	var random_adjective = GameState.adjectives[rarity][random_index];
	return random_adjective

#todo: nouns and interjection generation
#static func get_random_noun() -> NounData:
	#var rarity = get_random_rarity()
	#var random_index = randi_range(0, GameState.nouns[rarity].size() - 1)
	#var random_noun = GameState.nouns[rarity][random_index];
	#return random_noun

static func generate_loot() -> Loot:
#	TODO: write a roll for chance to drop loot?
	var partOfSpeech = Utils.get_random_part_of_speech()
	var rnd_item
	var loot_data = LootData.new()
	loot_data.partOfSpeech = partOfSpeech
	
	if partOfSpeech == "adj":
		rnd_item = Utils.get_random_adjective()
		loot_data.resource = rnd_item
		loot_data.asset = preload("res://assets/adj/FFRK_Silence_Status_Icon.webp")
	elif partOfSpeech == "noun":
		# TODO handle nouns
		pass
	elif partOfSpeech == "interjections":
		# TODO handle interjections
		pass
		
	loot_data.word = rnd_item.word
	loot_data.rarity = rnd_item.rarity
	var loot_scene: PackedScene = preload("res://entities/loot/Loot.tscn")
	var loot_instance = loot_scene.instantiate()
	loot_instance.loot = loot_data 
	
	return loot_instance
	
	
static func spawn_loot(ref) -> void:
	var loot_instance = Utils.generate_loot()
	ref.get_tree().current_scene.add_child(loot_instance)
	loot_instance.global_position = ref.global_position

static func spawn_item(ref, item) -> void:
	ref.get_tree().current_scene.add_child(item)
	item.global_position = ref.global_position
