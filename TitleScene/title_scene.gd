extends Node2D

const START_LEVEL : String = "res://playground.tscn"

@export var music : AudioStream
@export var button_focus_audio : AudioStream
@export var button_press_audio : AudioStream

@onready var button_new: Button = $CanvasLayer/Control/Button_Start_Game
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	get_tree().paused = false  
	LevelManager.level_load_started.connect(exit_title_screen)
	setup_title_screen()

func setup_title_screen() -> void:
	GlobalAudioManager.play_music(music)
	button_new.pressed.connect(start_game)
	button_new.grab_focus()
	button_new.focus_entered.connect(play_audio.bind(button_focus_audio))

func start_game() -> void:
	play_audio(button_press_audio)
	GlobalAudioManager.stop_music()
	get_tree().change_scene_to_file(START_LEVEL)

func exit_title_screen() -> void:
	queue_free() 

func play_audio(_a : AudioStream) -> void:
	audio_stream_player.stream = _a
	audio_stream_player.play()
