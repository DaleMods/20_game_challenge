class_name Game9MainMenu
extends Control

const Enums = preload("res://Game9/Systems/enums.gd")
const Globals = preload("res://Game9/Systems/globals.gd")

var app_node: Node

func _ready() -> void:
	app_node = get_node(Globals.app_node_path)


func _on_new_game_pressed() -> void:
	app_node.systems_manager.play_sound_file(Globals.menu_click_sound)
	app_node.ui_manager.change_ui(Enums.UI.ui_game_setup)


func _on_options_pressed() -> void:
	app_node.systems_manager.play_sound_file(Globals.menu_click_sound)
	app_node.ui_manager.change_ui(Enums.UI.ui_options_menu)


func _on_exit_game_pressed() -> void:
	app_node.systems_manager.play_sound_file(Globals.menu_click_sound)
	app_node.exit_game()
