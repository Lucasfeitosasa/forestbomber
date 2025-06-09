extends Node

const PLAYER = preload("res://Player/player.tscn")
var player : Player
var player_spawned : bool = false

func _ready() -> void:
	add_player_instance()
	await get_tree().create_timer(0.2).timeout
	player_spawned = true

func add_player_instance() -> void:
	player = PLAYER.instantiate()
	add_child( player )
	pass
	
func remove_player():
	if player and player.get_parent():
		player.queue_free()
		player = null
		player_spawned = false
	
	
func revive_player():
	set_player_position_from_spawner()
	player.revive_player()



func set_player_position_from_spawner():
	var spawner = get_tree().get_first_node_in_group("PlayerSpawn")
	if spawner:
		player.global_position = spawner.global_position
	else:
		print("⚠️ PlayerSpawner não encontrado!")


func set_as_parent( _p : Node2D ) -> void:
	if player.get_parent():
		player.get_parent().remove_child( player )
	_p.add_child( player )

func unparent_player( _p : Node2D ) -> void:
	_p.remove_child( player )

func play_audio( _audio : AudioStream ) -> void:
	player.audio.stream = _audio
	player.audio.play()
