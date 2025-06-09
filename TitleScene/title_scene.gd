extends Node2D

const START_LEVEL : String = "res://Levels/Area01/01.tscn"

@export var music : AudioStream
@export var button_focus_audio : AudioStream
@export var button_press_audio : AudioStream

@onready var button_new: Button = $CanvasLayer/Control/Button_Start_Game
@onready var button_continue: Button = $CanvasLayer/Control/Button_Continue  
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	get_tree().paused = false  
	
	LevelManager.level_load_started.connect(exit_title_screen)
	$CanvasLayer/SplashScene.finished.connect( setup_title_screen )
	pass


func setup_title_screen() -> void:
	AudioManager.play_music(music)

	button_new.pressed.connect(start_game)
	button_new.focus_entered.connect(play_audio.bind(button_focus_audio))
	button_new.pressed.connect(play_audio.bind(button_press_audio))


	var has_save = SaveManager.get_save_file() != null
	button_continue.visible = has_save
	if has_save:
		button_continue.pressed.connect(continue_game)
		button_continue.focus_entered.connect(play_audio.bind(button_focus_audio))
		button_continue.pressed.connect(play_audio.bind(button_press_audio))
		button_continue.grab_focus()
	else:
		button_new.grab_focus()


func start_game() -> void:
	play_audio(button_press_audio)
	AudioManager.stop_music()
	get_tree().change_scene_to_file(START_LEVEL)
	
func continue_game() -> void:
	play_audio(button_press_audio)
	AudioManager.stop_music()
	SaveManager.load_game()

func exit_title_screen() -> void:
	self.queue_free()

func play_audio(_a : AudioStream) -> void:
	audio_stream_player.stream = _a
	audio_stream_player.play()
