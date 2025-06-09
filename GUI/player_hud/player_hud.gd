extends CanvasLayer

@export var button_focus_audio : AudioStream = preload( "res://TitleScene/audio/menu_focus.wav" )
@export var button_select_audio : AudioStream = preload( "res://TitleScene/audio/menu_select.wav" )


@onready var game_over : Control = $GameOver
@onready var try_again_button: Button = $GameOver/VBoxContainer/TryAgainButton
@onready var title_button: Button = $GameOver/VBoxContainer/TitleButton
@onready var animation_player: AnimationPlayer = $GameOver/AnimationPlayer
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	hide_game_over_screen()
	try_again_button.focus_entered.connect(play_audio.bind( button_focus_audio ) )
	try_again_button.pressed.connect(SaveManager.load_game)
	title_button.focus_entered.connect( play_audio.bind( button_focus_audio ) )
	title_button.pressed.connect( title_screen )
	LevelManager.level_load_started.connect( hide_game_over_screen )
	pass


	
func show_game_over_screen() -> void:
	game_over.visible = true
	game_over.mouse_filter = Control.MOUSE_FILTER_STOP
	
	var can_continue : bool = SaveManager.get_save_file() != null
	try_again_button.visible = can_continue
	
	animation_player.play("show_game_over")
	await animation_player.animation_finished
	
	if can_continue == true:
		try_again_button.grab_focus()
	else:
		title_button.grab_focus()
	
func hide_game_over_screen() -> void:
	game_over.visible = false
	game_over.mouse_filter = Control.MOUSE_FILTER_IGNORE
	game_over.modulate = Color( 1,1,1,0 )


	
func title_screen() -> void:
	play_audio( button_select_audio )
	await fade_to_black()
	LevelManager.load_new_level("res://TitleScene/title_scene.tscn")
	
func fade_to_black() -> bool:
	animation_player.play("fade_to_black")
	await animation_player.animation_finished
	PlayerManager.player.revive_player()
	return true


func play_audio( _a : AudioStream ) -> void:
	audio.stream = _a
	audio.play()
