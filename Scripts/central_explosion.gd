extends Area2D

class_name CentralExplosion

@onready var sound_explosion = $sound_explosion

@onready var raycasts: Array[RayCast2D] = [
	$RayCasts/RayCastUp,
	$RayCasts/RayCastRight,
	$RayCasts/RayCastDown,
	$RayCasts/RayCastLeft
]

var animation_names = ["up", "right", "down", "left"]
var animation_directions: Array[Vector2] = [
	Vector2(0, -TILE_SIZE),
	Vector2(TILE_SIZE, 0),
	Vector2(0, TILE_SIZE),
	Vector2(-TILE_SIZE, 0)
]

const DIRECTIONAL_EXPLOSION = preload("res://directional_explosion.tscn")

var size = 1
const TILE_SIZE = 32

func _ready() -> void:
	check_raycasts()
	
func check_raycasts():
	for i in raycasts.size():
		check_raycast_for_direction(animation_names[i], raycasts[i], animation_directions[i])
#	

func check_raycast_for_direction(animation_name: String, raycast: RayCast2D, animation_direction: Vector2):	
	raycast.target_position = animation_direction.normalized() * TILE_SIZE * size
	raycast.force_raycast_update()

	if !raycast.is_colliding():
		create_explosion_for_size(size, animation_name, animation_direction)
	else: 
		var size_of_explosion = calculate_size_of_explosion(raycast)
		var collider = raycast.get_collider()
		if size_of_explosion != null:
			create_explosion_for_size(size_of_explosion, animation_name, animation_direction)
		sound_explosion.play()
		execute_explosion_collision(collider)


func create_explosion_for_size(size: int, animation_name: String, animation_position: Vector2):
	for i in size: 
		if i < size - 1:
			create_explosion_animation_slice("%s_middle" % animation_name, animation_position * (i+1))
		else: 
			create_explosion_animation_slice("%s_end" % animation_name, animation_position * (i+1))
	

func create_explosion_animation_slice(animation_name: String, animation_position: Vector2):
	print_debug(animation_name)
	var directional_explosion = DIRECTIONAL_EXPLOSION.instantiate()
	directional_explosion.position = animation_position
	add_child(directional_explosion)
	directional_explosion.play_animation(animation_name)
	
func calculate_size_of_explosion(raycast: RayCast2D):
	var collider = raycast.get_collider()
	if collider is TileMap:
		var collision_point = raycast.get_collision_point()
		
		var distance_to_collider = raycast.global_position.distance_to(collision_point)
		var size_of_explosion_before_collider = max(roundi(absf(distance_to_collider)/ TILE_SIZE - 1), 0)
		return size_of_explosion_before_collider

func execute_explosion_collision(collider: Object):
	if collider is Barrels:
		(collider as Barrels).destroy()



func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		(body as Player).die()
		
	if body is Enemy:
		(body as Enemy).die()
