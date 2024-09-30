class_name Game9OptionsManager
extends Node

signal changed_audio_master_mute
signal changed_audio_sound_volume
signal changed_audio_music_volume
signal changed_window_mode_index
signal changed_resolution_mode_index
signal changed_vsync_mode_index
signal changed_max_fps

const Enums = preload("res://Game9/Systems/enums.gd")
const Globals = preload("res://Game9/Systems/globals.gd")

var options_data = Game9OptionsData.new()
var save_file_path = Globals.options_save_file_path
var save_file_name = Globals.options_save_file_name
var app_node: Node


func _ready() -> void:
	app_node = get_node(Globals.app_node_path)
	verify_options_save_directory(save_file_path)


func initialise():
	load_options()


func verify_options_save_directory(path: String):
	DirAccess.make_dir_absolute(path)


func save_options():
	ResourceSaver.save(options_data, save_file_path + save_file_name)


func save_default_options():
	var default_options = Game9OptionsData.new()
	ResourceSaver.save(default_options, save_file_path + save_file_name)


func load_options():
	var options = null
	if FileAccess.file_exists(save_file_path + save_file_name):
		options = ResourceLoader.load(save_file_path + save_file_name)
	if options != null:
		options_data = options.duplicate(true)
		change_option(Enums.OPTION.audio_master_mute, options_data.audio_master_mute)
		change_option(Enums.OPTION.audio_sound_volume, options_data.audio_sound_volume)
		change_option(Enums.OPTION.audio_music_volume, options_data.audio_music_volume)
		change_option(Enums.OPTION.window_mode_index, options_data.window_mode_index)
		change_option(Enums.OPTION.resolution_mode_index, options_data.resolution_mode_index)
		change_option(Enums.OPTION.vsync_mode_index, options_data.vsync_mode_index)
		change_option(Enums.OPTION.max_fps, options_data.max_fps)
	else:
		save_default_options()


func change_option(option: Enums.OPTION, state):
	match option:
		Enums.OPTION.audio_master_mute:
			options_data.audio_master_mute = state
			emit_signal("changed_audio_master_mute", state)
		Enums.OPTION.audio_sound_volume:
			options_data.audio_sound_volume = state
			emit_signal("changed_audio_sound_volume", state)
		Enums.OPTION.audio_music_volume:
			options_data.audio_music_volume = state
			emit_signal("changed_audio_music_volume", state)
		Enums.OPTION.window_mode_index:
			options_data.window_mode_index = state
			set_window_mode(state)
			emit_signal("changed_window_mode_index", state)
		Enums.OPTION.resolution_mode_index:
			options_data.resolution_mode_index = state
			set_resolution_mode(state)
			emit_signal("changed_resolution_mode_index", state)
		Enums.OPTION.vsync_mode_index:
			options_data.vsync_mode_index = state
			set_vsync_mode(state)
			emit_signal("changed_vsync_mode_index", state)
		Enums.OPTION.max_fps:
			options_data.max_fps = state
			set_fps(options_data.max_fps)
			emit_signal("changed_max_fps", state)
	save_options()


func get_option(option: Enums.OPTION):
	match option:
		Enums.OPTION.audio_master_mute:
			return options_data.audio_master_mute
		Enums.OPTION.audio_sound_volume:
			return options_data.audio_sound_volume
		Enums.OPTION.audio_music_volume:
			return options_data.audio_music_volume
		Enums.OPTION.window_mode_index:
			return options_data.window_mode_index
		Enums.OPTION.resolution_mode_index:
			return options_data.resolution_mode_index
		Enums.OPTION.vsync_mode_index:
			return options_data.vsync_mode_index
		Enums.OPTION.max_fps:
			return options_data.max_fps


func set_window_mode(_value):
	pass


func set_resolution_mode(_value):
	pass


func set_vsync_mode(_value):
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)


func set_fps(value):
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	Engine.max_fps = value
