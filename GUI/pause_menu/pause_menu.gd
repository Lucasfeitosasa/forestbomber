extends CanvasLayer

signal shown
signal hidden

@export var button_focus_audio : AudioStream = preload("res://TitleScene/audio/menu_focus.wav")
@export var button_select_audio : AudioStream = preload("res://TitleScene/audio/menu_select.wav")

@onready var audio: AudioStreamPlayer = $Control/AudioStreamPlayer

@onready var audio_stream_player: AudioStreamPlayer = $Control/AudioStreamPlayer

@onready var button_save: Button = $VBoxContainer/Button_Save
@onready var button_load: Button = $VBoxContainer/Button_Load
@onready var button_title: Button = $VBoxContainer/Button_Title 

var is_paused : bool = false

func _ready() -> void:
	hide_pause_menu()


	button_save.focus_entered.connect(play_audio.bind(button_focus_audio))
	button_save.pressed.connect(play_select_audio)
	button_save.pressed.connect(_on_save_pressed)

	button_load.focus_entered.connect(play_audio.bind(button_focus_audio))
	button_load.pressed.connect(play_select_audio)
	button_load.pressed.connect(_on_load_pressed)

	button_title.focus_entered.connect(play_audio.bind(button_focus_audio))
	button_title.pressed.connect(play_select_audio)
	button_title.pressed.connect(_on_title_pressed)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if is_paused == false:
			show_pause_menu()
		else:
			hide_pause_menu()
		get_viewport().set_input_as_handled()

func show_pause_menu() -> void:
	get_tree().paused = true
	visible = true
	is_paused = true
	shown.emit()

	button_save.grab_focus()


func hide_pause_menu() -> void:
	get_tree().paused = false
	visible = false
	is_paused = false
	hidden.emit()

func _on_save_pressed() -> void:
	if is_paused == false:
		return
	SaveManager.save_game()
	hide_pause_menu()

func _on_load_pressed() -> void:
	if is_paused == false:
		return
	SaveManager.load_game()
	await LevelManager.level_load_started
	hide_pause_menu()

func _on_title_pressed() -> void:
	if is_paused == false:
		return
	hide_pause_menu()
	await LevelManager.load_new_level("res://TitleScene/title_scene.tscn")

func play_audio(audio_stream: AudioStream) -> void:
	audio.stream = audio_stream
	audio.play()

func play_select_audio() -> void:
	play_audio(button_select_audio)
