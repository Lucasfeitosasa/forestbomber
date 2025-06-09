extends CanvasLayer

@onready var animation_player: AnimationPlayer = $ShowCongrats/AnimationPlayer


func show_black() -> bool:
	animation_player.play("show_congrats")
	await animation_player.animation_finished
	return true


func to_black() -> bool:
	animation_player.play("to_black")
	await animation_player.animation_finished
	return true
