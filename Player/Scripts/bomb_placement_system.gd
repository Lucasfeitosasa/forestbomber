extends Node2D
class_name BombPlacementSystem

const BOMB_SCENE = preload("res://bomb.tscn")
const TILE_SIZE = 32

var player: Player = null
var bombs_placed = 0
var explosion_size = 1

func _ready() -> void:
	player = get_parent()

func place_bomb():
	if bombs_placed == player.max_bombs_at_once:
		return 

	var player_position = player.position
	var bomb_position = player_position.snapped(Vector2(TILE_SIZE, TILE_SIZE))

	# Verificar se já existe uma bomba ou obstáculo naquele tile
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = bomb_position
	query.collide_with_areas = true
	query.collide_with_bodies = true

	var result = space_state.intersect_point(query, 1)

	for item in result:
		if item.collider and item.collider.is_in_group("bomb_block"):
			return  # Já existe algo bloqueando

	# Instanciar bomba
	var bomb = BOMB_SCENE.instantiate()
	bomb.position = bomb_position
	get_tree().root.add_child(bomb)
	bomb.add_to_group("bomb_block")

	# Temporariamente desativa colisão para o jogador poder sair do tile
	if bomb.has_node("CollisionShape2D"):
		var col = bomb.get_node("CollisionShape2D")
		col.disabled = true
		await get_tree().create_timer(0.5).timeout
		col.disabled = false

	bombs_placed += 1
	bomb.tree_exiting.connect(on_bomb_exploded)

func on_bomb_exploded():
	bombs_placed -= 1
