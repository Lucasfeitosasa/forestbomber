extends Node2D


func _ready() -> void:
	add_to_group("PlayerSpawn")

	visible = false
	if PlayerManager.player_spawned == false:
		PlayerManager.set_player_position( global_position )
		PlayerManager.player_spawned = true
