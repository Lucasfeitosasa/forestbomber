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

func _physics_process( delta ):
	move_and_slide()


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
	animation_player.play("die")
	direction = Vector2.ZERO
	set_process_input(false)
