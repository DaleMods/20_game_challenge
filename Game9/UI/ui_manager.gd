class_name Game9UIManager
extends Control

const Enums = preload("res://Game9/Systems/enums.gd")
const Globals = preload("res://Game9/Systems/globals.gd")

var main_menu_scene = preload("res://Game9/UI/MainMenu/main_menu.tscn")
var options_menu_scene = preload("res://Game9/UI/OptionsMenu/options_menu.tscn")
var debug_overlay_scene = preload("res://Game9/UI/DebugOverlay/debug_overlay.tscn")
var game_hud_scene = preload("res://Game9/UI/GameHud/game_hud.tscn")
var game_setup_scene = preload("res://Game9/UI/GameSetup/game_setup.tscn")

var app_node: Node
var debug_overlay_active = false
var game_ui: Node
var current_ui


func _ready() -> void:
	app_node = get_node(Globals.app_node_path)
	current_ui = Enums.UI.ui_none


func initialise():
	app_node.systems_manager.key_pressed.connect(_on_key_pressed)


func change_ui(ui_enum):
	unload_current_ui()
	load_new_ui(ui_enum)


func load_new_ui(ui_enum):
	var load_ui
	match ui_enum:
		Enums.UI.ui_game_hud:
			load_ui = game_hud_scene.instantiate()
			load_ui.name = "GameHud"
			game_ui = load_ui
		Enums.UI.ui_game_setup:
			load_ui = game_setup_scene.instantiate()
			load_ui.name = "GameSetup"
		Enums.UI.ui_main_menu:
			load_ui = main_menu_scene.instantiate()
			load_ui.name = "MainMenu"
		Enums.UI.ui_options_menu:
			load_ui = options_menu_scene.instantiate()
			load_ui.name = "OptionsMenu"
	add_child(load_ui)
	current_ui = ui_enum


func unload_current_ui():
	var unload_ui
	match current_ui:
		Enums.UI.ui_none:
			return
		Enums.UI.ui_game_hud:
			unload_ui = "GameHud"
		Enums.UI.ui_game_setup:
			unload_ui = "GameSetup"
		Enums.UI.ui_main_menu:
			unload_ui = "MainMenu"
		Enums.UI.ui_options_menu:
			unload_ui = "OptionsMenu"
	var unload_node = get_node(unload_ui)
	unload_node.queue_free()


func show_debug_overlay(state):
	debug_overlay_active = state
	if state:
		var debug_overlay = debug_overlay_scene.instantiate()
		debug_overlay.name = "DebugOverlay"
		add_child(debug_overlay)
	else:
		if has_node("DebugOverlay"):
			var node = get_node("DebugOverlay")
			node.queue_free()


func _on_key_pressed(key):
	if key == KEY_F1:
		show_debug_overlay(!debug_overlay_active)
