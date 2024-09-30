class_name Game9SystemsManager
extends Node

@onready var options_manager: Game9OptionsManager = $OptionsManager
@onready var audio_manager: Game9AudioManager = $AudioManager
@onready var input_manager: Game9InputManager = $InputManager

const Enums = preload("res://Game9/Systems/enums.gd")

signal key_pressed
signal key_released
signal changed_audio_master_mute
signal changed_audio_sound_volume
signal changed_audio_music_volume
signal changed_window_mode_index
signal changed_resolution_mode_index
signal changed_vsync_mode_index
signal changed_max_fps


func initialise():
	input_manager.key_pressed.connect(on_key_pressed)
	input_manager.key_released.connect(on_key_released)
	
	options_manager.changed_audio_master_mute.connect(on_changed_audio_master_mute)
	options_manager.changed_audio_sound_volume.connect(on_changed_audio_sound_volume)
	options_manager.changed_audio_music_volume.connect(on_changed_audio_music_volume)
	options_manager.changed_window_mode_index.connect(on_changed_window_mode_index)
	options_manager.changed_resolution_mode_index.connect(on_changed_resolution_mode_index)
	options_manager.changed_vsync_mode_index.connect(on_changed_vsync_mode_index)
	options_manager.changed_max_fps.connect(on_changed_max_fps)
	
	audio_manager.initialise()
	options_manager.initialise()


# Input Manager access
func on_key_pressed(key):
	emit_signal("key_pressed", key)
func on_key_released(key):
	emit_signal("key_released", key)
func has_key_down(key):
	if input_manager.keys_down.has(key):
		return true
	return false


# Audio Manager access
func play_music_file(file_name, loop):
	audio_manager.play_music_file(file_name, loop)
func play_sound_file(file_name):
	audio_manager.play_sound_file(file_name)


# Options Manager access
func change_option(option: Enums.OPTION, state):
	options_manager.change_option(option, state)
func get_option(option: Enums.OPTION):
	return options_manager.get_option(option)
func save_options():
	options_manager.save_options()


# Signal forwarding
func on_changed_audio_master_mute(state):
	emit_signal("changed_audio_master_mute", state)
func on_changed_audio_sound_volume(state):
	emit_signal("changed_audio_sound_volume", state)
func on_changed_audio_music_volume(state):
	emit_signal("changed_audio_music_volume", state)
func on_changed_window_mode_index(state):
	emit_signal("changed_window_mode_index", state)
func on_changed_resolution_mode_index(state):
	emit_signal("changed_resolution_mode_index", state)
func on_changed_vsync_mode_index(state):
	emit_signal("changed_vsync_mode_index", state)
func on_changed_max_fps(state):
	emit_signal("changed_max_fps", state)
