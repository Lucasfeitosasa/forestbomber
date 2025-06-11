extends CharacterBody2D
class_name EnemyBoss

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export var collision_tile_layer: int = 2
@export var speed: float = 25.0
@export var direction_intersection_change_chance: float = 0.5
@export var change_direction_timeout: float = 3.0
@export var bomb_scene: PackedScene
@export var bomb_placement_cooldown: float = 4.0

var direction: Vector2 = Vector2.LEFT
var current_change_direction_timeout: float = 0.0
var bomb_cooldown_timer: float = 0.0
var has_active_bomb: bool = false
var placing_bomb: bool = false
var tile_map: TileMap
var run_from_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	tile_map = get_tree().get_first_node_in_group("tilemap")
	change_sprite_direction(direction)
	
func _physics_process(delta: float) -> void:
	if placing_bomb:
		return

	bomb_cooldown_timer -= delta
	if bomb_cooldown_timer <= 0 and not has_active_bomb:
		placing_bomb = true
		bomb_cooldown_timer = bomb_placement_cooldown
		play_bomb_animation()
		return

	var velocity = direction * speed

	if direction == Vector2.LEFT or direction == Vector2.RIGHT:
		position.y = roundf(position.y / 16) * 16
	elif direction == Vector2.UP or direction == Vector2.DOWN:
		position.x = roundf(position.x / 16) * 16

	if is_on_wall():
		direction = calculate_new_direction(direction, true)

	move_and_slide()

	if roundi(position.x) % 16 == 0 and roundi(position.y) % 16 == 0:
		if current_change_direction_timeout >= change_direction_timeout and randf() <= direction_intersection_change_chance:
			direction = calculate_new_direction(direction, true)
			current_change_direction_timeout = 0

	current_change_direction_timeout += delta

func play_bomb_animation():
	if direction.x != 0:
		animated_sprite_2d.animation = "bomb_side"
	elif direction.y < 0:
		animated_sprite_2d.animation = "bomb_up"
	else:
		animated_sprite_2d.animation = "bomb_down"
	
	animated_sprite_2d.play()

func _on_AnimatedSprite2D_animation_finished():
	if animated_sprite_2d.animation.begins_with("bomb_"):
		spawn_bomb()
		placing_bomb = false
		change_sprite_direction(direction)

func spawn_bomb():
	var bomb = bomb_scene.instantiate()
	bomb.position = position.snapped(Vector2(16, 16))
	get_tree().root.add_child(bomb)
	has_active_bomb = true
	bomb.tree_exiting.connect(func(): has_active_bomb = false)

func change_sprite_direction(new_direction: Vector2):
	if new_direction.x != 0:
		animated_sprite_2d.animation = "walk_side"
		animated_sprite_2d.flip_h = new_direction.x > 0
	elif new_direction.y < 0:
		animated_sprite_2d.animation = "walk_side"
		animated_sprite_2d.flip_h = false
	else:
		animated_sprite_2d.animation = "walk_side"
		animated_sprite_2d.flip_h = true
	
	animated_sprite_2d.play()

func calculate_new_direction(current_direction: Vector2, prevent_backtracking: bool) -> Vector2:
	var all_directions = [Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN]
	var possible_directions: Array[Vector2] = []
	all_directions.erase(current_direction)

	if prevent_backtracking:
		all_directions.erase(-current_direction)

	for d in all_directions:
		if not is_direction_blocked(d):
			possible_directions.append(d)

	if possible_directions.size() > 0:
		var new_direction = possible_directions[randi_range(0, possible_directions.size() - 1)]
		change_sprite_direction(new_direction)
		return new_direction

	return current_direction

func is_direction_blocked(dir: Vector2) -> bool:
	var check_position = (position + dir * 16).snapped(Vector2(16, 16))
	var local_pos = tile_map.to_local(check_position)
	var tile_pos = tile_map.local_to_map(local_pos)

	if not tile_map.get_used_rect().has_point(tile_pos):
		return true

	var tile_data = tile_map.get_cell_tile_data(collision_tile_layer, tile_pos)
	return tile_data != null

func _on_area_entered(area: Area2D) -> void:
	if area.name.begins_with("explosion"):
		var away_direction = (position - area.global_position).normalized().round()
		direction = calculate_new_direction(away_direction, false)
