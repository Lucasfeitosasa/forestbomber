extends CanvasLayer

signal shown
signal hidden

@onready var audio_stream_player: AudioStreamPlayer = $Control/AudioStreamPlayer

@onready var tab_container: TabContainer = $Control/TabContainer


@onready var button_quit: Button = $Control/TabContainer/System/VBoxContainer/Button_Quit

@onready var item_description: Label = $Control/TabContainer/Inventory/ItemDescription

var is_paused : bool = false



func _ready() -> void:
	hide_pause_menu()




func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if is_paused == false:
			show_pause_menu()
		else:
			hide_pause_menu()
		get_viewport().set_input_as_handled()
	
	if is_paused:
		if event.is_action_pressed("right_bumper"):
			change_tab( 1 )
		elif event.is_action_pressed("left_bumper"):
			change_tab( -1 )


func show_pause_menu() -> void:
	get_tree().paused = true
	visible = true
	is_paused = true
	tab_container.current_tab = 0
	shown.emit()



func hide_pause_menu() -> void:
	get_tree().paused = false
	visible = false
	is_paused = false
	hidden.emit()



func _on_load_pressed() -> void:
	await LevelManager.level_load_started
	hide_pause_menu()
	pass



func _on_quit_pressed() -> void:
	get_tree().quit()


func play_audio( audio : AudioStream ) -> void:
	audio_stream_player.stream = audio
	audio_stream_player.play()



func change_tab( _i : int = 1 ) -> void:
	tab_container.current_tab = wrapi(
			tab_container.current_tab + _i,
			0,
			tab_container.get_tab_count()
		)
	tab_container.get_tab_bar().grab_focus()
