extends StaticBody2D

class_name Barrels

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var is_destroying := false

func destroy():
	if is_destroying:
		return # já está destruindo, evita múltiplas chamadas
	is_destroying = true

	collision_shape_2d.disabled = true
	set_deferred("monitoring", false) # para evitar novas colisões com explosões
	animated_sprite_2d.play("destroy")


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "destroy":
		queue_free()
