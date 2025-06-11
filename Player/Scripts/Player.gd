class_name Player extends CharacterBody2D


var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
var max_bombs_at_once = 1

@onready var animation_player = $AnimatedSprite2D
@onready var state_machine : PlayerStateMachine = $StateMachine
@onready var raycasts: Raycasts = $Raycasts
@onready var bomb_placement_system: BombPlacementSystem = $BombPlacementSystem



func _ready():
	state_machine.Initialize(self)
	pass 



func _process(delta):
	##direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	##direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	direction = Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
	).normalized()
	
	var collisions = raycasts.check_collision()
	
	if collisions.has(direction):
		return
	
	if Input.is_action_just_pressed("place_bomb"):
		bomb_placement_system.place_bomb()
	
	pass 

func clamp_position_within_bounds():
	var bounds = LevelManager.current_tilemap_bounds
	if bounds.size() == 2:
		var margin = 8  # evita que o jogador encoste totalmente na borda
		global_position.x = clamp(global_position.x, bounds[0].x + margin, bounds[1].x - margin)
		global_position.y = clamp(global_position.y, bounds[0].y + margin, bounds[1].y - margin)


func _physics_process(delta):
	# lógica de movimento do player
	move_and_slide()

	# restringe aos limites do mapa
	clamp_position_within_bounds()

	
func SetDirection() -> bool:
	var new_dir : Vector2 = cardinal_direction
	if direction == Vector2.ZERO:
		return false
		
	if direction.y == 0:
		new_dir = Vector2.LEFT if direction.x < 0 else Vector2.RIGHT
	elif direction.x == 0:
		new_dir = Vector2.UP if direction.y < 0 else Vector2.DOWN
	
	elif Input.is_action_just_pressed("place_bomb"):
		bomb_placement_system.place_bomb()
	
	if new_dir == cardinal_direction: 
		return false
	
	
	cardinal_direction = new_dir
	animation_player.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	return true 
	
	


func UpdateAnimation( state : String) -> void:
	animation_player.play( state + "_" + AnimDirection())
	pass

func AnimDirection() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"



func die():
	set_physics_process(false)
	animation_player.play("die")
	direction = Vector2.ZERO
	PlayerHud.show_game_over_screen()
	
	set_process_input(false)



func _on_animated_sprite_2d_animation_finished() -> void:
	if animation_player.animation == "die":
		set_physics_process(false)
		set_process(false)
		set_process_input(false)
		collision_layer = 0
		collision_mask = 0


func revive_player():
	show()
	animation_player.play("idle_down")
	global_position = Vector2.ZERO
	direction = Vector2.ZERO
	cardinal_direction = Vector2.DOWN
	collision_layer = 1
	collision_mask = (1 << 2) | (1 << 3) | (1 << 4)
	
	set_process(true)
	set_physics_process(true)
	set_process_input(true)
