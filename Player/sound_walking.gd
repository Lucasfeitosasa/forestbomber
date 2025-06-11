extends AudioStreamPlayer2D

func _input(event):
	if Input.is_action_pressed("down") or Input.is_action_pressed("left") or Input.is_action_pressed("up") or Input.is_action_pressed("right"): # Substitua "pause_sound" pela ação definida
		if !is_playing():
			play()
	else:
		if is_playing():
			stop()
