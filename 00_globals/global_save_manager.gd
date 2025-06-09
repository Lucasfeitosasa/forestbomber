extends Node

const SAVE_PATH = "user://"


signal game_loaded
signal game_saved

var current_save : Dictionary = {
	scene_path = ""
}




func save_game() -> void:
	update_scene_path()
	var file := FileAccess.open(SAVE_PATH + "save.sav", FileAccess.WRITE)
	var save_json = JSON.stringify(current_save)
	file.store_line(save_json)
	game_saved.emit()

func get_save_file() -> FileAccess:
	return FileAccess.open(SAVE_PATH + "save.sav", FileAccess.READ)

func load_game() -> void:
	var file := get_save_file()
	var json := JSON.new()
	json.parse(file.get_line())
	var save_dict : Dictionary = json.get_data() as Dictionary
	current_save = save_dict

	await LevelManager.load_new_level(current_save.scene_path)
	await LevelManager.level_loaded

	PlayerManager.revive_player()
	game_loaded.emit()

func update_scene_path() -> void:
	for c in get_tree().root.get_children():
		if c is Level:
			current_save.scene_path = c.scene_file_path
