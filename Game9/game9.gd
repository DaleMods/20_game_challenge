class_name Game9App
extends Node

@onready var systems_manager: Game9SystemsManager = $SystemsManager
@onready var ui_manager: Control = $UIManager
@onready var game_manager: Game9GameManager = $GameManager

const Enums = preload("res://Game9/Systems/enums.gd")
const Globals = preload("res://Game9/Systems/globals.gd")

var game_loaded = false
var initialised = false


func _ready() -> void:
	game_loaded = true
	show_menu()


func _process(_delta: float) -> void:
	if initialised == false:
		initialise()


func initialise():
	ui_manager.initialise()
	systems_manager.initialise()
	initialised = true
#	systems_manager.audio_manager.play_music_file(Globals.music_song_1, true)


func show_menu():
	ui_manager.change_ui(Enums.UI.ui_main_menu)


func new_game(track_num, num_players, num_laps):
	game_manager.new_game(track_num, num_players, num_laps)


func exit_game():
	get_tree().change_scene_to_file("res://Scenes/menu_system.tscn")
	game_loaded = false
