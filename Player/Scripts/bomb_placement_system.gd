extends Node

class_name BombPlacementSystem

const BOMB_SCENE = preload("res://bomb.tscn")

const TILE_SIZE = 16

var player: Player = null
var bombs_placed = 0
var explosion_size = 1

func _ready() -> void:
	player = get_parent()
	
func place_bomb():
	if bombs_placed == player.max_bombs_at_once:
		return 

	var bomb = BOMB_SCENE.instantiate()
	var player_position = player.position

	var bomb_position = player_position.snapped(Vector2(32, 32))
	bomb.position = bomb_position

	get_tree().root.add_child(bomb)
	bombs_placed += 1
	bomb.tree_exiting.connect(on_bomb_exploded)

func on_bomb_exploded():
	bombs_placed -= 1
