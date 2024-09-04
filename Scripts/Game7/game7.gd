extends Node2D

@onready var players: Node = $Players

var this_scene_loaded = false
var music_on = true
var sounds_on = true


func _ready() -> void:
	this_scene_loaded = true
	do_menu()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Escape"):
		get_tree().change_scene_to_file("res://Scenes/menu_system.tscn")
		this_scene_loaded = false
		return
	
	if music_on:
		if $BackgroundMusic.playing == false:
			$BackgroundMusic.play()
	else:
		if $BackgroundMusic.playing:
			$BackgroundMusic.stop()


func do_menu():
	$MainMenu.visible = true
	$GameOverUI.visible = false
	$Terrain.clear_objects()
	$Terrain.visible = false


func do_new_game():
	$MainMenu.visible = false
	$Terrain.visible = true
	$Terrain.new_terrain()
	$Camera2D.make_current()
	players.setup_new_players()


func do_game_over(winner):
	$Camera2D.make_current()
	$GameOverUI.show_game_over(winner)
