class_name Game9GameManager
extends Node

const Enums = preload("res://Game9/Systems/enums.gd")
const Globals = preload("res://Game9/Systems/globals.gd")

var app_node: Node
var race_ended = false


func _ready():
	app_node = get_node(Globals.app_node_path)


func show_menu():
	if has_node("World"):
		get_node("World").queue_free()
	app_node.show_menu()


func new_game(track_num, num_players, num_laps):
	app_node.ui_manager.change_ui(Enums.UI.ui_game_hud)
	if !app_node.systems_manager.key_pressed.is_connected(_on_key_pressed):
		app_node.systems_manager.key_pressed.connect(_on_key_pressed)
	var world_scene = preload("res://Game9/Game/world.tscn")
	var world = world_scene.instantiate()
	world.name = "World"
	add_child(world)
	world.new_game(track_num, num_players, num_laps)


func _on_key_pressed(key):
	if key == KEY_ESCAPE:
		show_menu()
	if race_ended and key == KEY_SPACE:
		show_menu()
