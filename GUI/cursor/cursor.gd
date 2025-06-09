extends Sprite2D

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	z_index = 9999  


func _process(_delta: float) -> void:
	global_position = get_global_mouse_position()
	
	var desired_rotation: float = -12.5 if Input.is_action_just_pressed("click") else 0.0
	rotation_degrees = lerp(rotation_degrees, desired_rotation, 16.5*_delta)
	
	var desired_scale: Vector2 = Vector2(0.35, 0.35) if Input.is_action_just_pressed("click") else Vector2(0.4,0.4)
	scale = lerp(scale,desired_scale, 16.5*_delta)
