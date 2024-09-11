extends Node

var game_scene = preload("res://Scenes/Game8/game_manager.tscn")

var this_scene_loaded = false
var in_game = false


func _ready() -> void:
	this_scene_loaded = true


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Escape"):
		get_tree().change_scene_to_file("res://Scenes/menu_system.tscn")
		this_scene_loaded = false
		return
	
	if $Music.playing == false:
		$Music.playing = true


func show_menu():
	in_game = false
	$UI.visible = true


func new_game():
	in_game = true
	$UI.visible = false
	var game = game_scene.instantiate()
	game.name = "GameManager"
	add_child(game)
	game.new_game()


func _on_new_game_pressed() -> void:
	new_game()


func _on_exit_pressed() -> void:
		get_tree().change_scene_to_file("res://Scenes/menu_system.tscn")
		this_scene_loaded = false
