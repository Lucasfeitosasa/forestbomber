extends Node

@export_file("*.tscn") var next_level_path : String

var level_completed := false

func _ready() -> void:
	# Verifica a cada "check_delay" segundos
	var check_timer := Timer.new()
	check_timer.autostart = true
	check_timer.one_shot = false
	check_timer.timeout.connect(_check_enemies)
	add_child(check_timer)

func _check_enemies() -> void:
	if level_completed:
		return
	
	var enemies := get_tree().get_nodes_in_group("enemy")
	if enemies.is_empty():
		level_completed = true
		# Transição para a próxima fase
		LevelManager.load_new_level(next_level_path)
