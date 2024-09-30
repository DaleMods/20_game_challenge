class_name Game9OptionsMenu
extends MarginContainer

@onready var max_fps_slider: HSlider = $PanelContainer/MarginContainer/VBoxContainer/MaxFPSContainer/MaxFPSSlider
@onready var max_fps_value: Label = $PanelContainer/MarginContainer/VBoxContainer/MaxFPSContainer/MaxFPSValue
@onready var master_mute_checkbox: CheckBox = $PanelContainer/MarginContainer/VBoxContainer/MasterMuteContainer/MasterMuteCheckbox
@onready var music_volume_slider: HSlider = $PanelContainer/MarginContainer/VBoxContainer/MusicVolumeContainer/MusicVolumeSlider
@onready var music_volume_value: Label = $PanelContainer/MarginContainer/VBoxContainer/MusicVolumeContainer/MusicVolumeValue
@onready var sound_volume_slider: HSlider = $PanelContainer/MarginContainer/VBoxContainer/SoundVolumeContainer/SoundVolumeSlider
@onready var sound_volume_value: Label = $PanelContainer/MarginContainer/VBoxContainer/SoundVolumeContainer/SoundVolumeValue

const Enums = preload("res://Game9/Systems/enums.gd")
const Globals = preload("res://Game9/Systems/globals.gd")

var app_node: Node
var systems_manager: Node


func _ready():
	app_node = get_node(Globals.app_node_path)
	systems_manager = app_node.systems_manager
	setup_display_options()
	setup_audio_options()


func setup_display_options():
	max_fps_slider.max_value = 1000
	update_max_fps_slider(systems_manager.get_option(Enums.OPTION.max_fps))


func setup_audio_options():
	master_mute_checkbox.set_pressed_no_signal(systems_manager.get_option(Enums.OPTION.audio_master_mute))
	update_music_volume_slider(systems_manager.get_option(Enums.OPTION.audio_music_volume))
	update_sound_volume_slider(systems_manager.get_option(Enums.OPTION.audio_sound_volume))


func _on_max_fps_slider_value_changed(value: float) -> void:
	update_max_fps_slider(value)


func _on_max_fps_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		var value = max_fps_slider.value
		systems_manager.change_option(Enums.OPTION.max_fps, value)
		update_max_fps_slider(value)


func update_max_fps_slider(value):
	max_fps_slider.value = value
	if max_fps_slider.value == 0:
		max_fps_value.text = "Unlimited"
	else:
		max_fps_value.text = str(max_fps_slider.value)


func _on_master_mute_checkbox_pressed() -> void:
	systems_manager.change_option(Enums.OPTION.audio_master_mute, !systems_manager.get_option(Enums.OPTION.audio_master_mute))


func update_music_volume_slider(value):
	music_volume_slider.value = value
	music_volume_value.text = str(value)


func update_sound_volume_slider(value):
	sound_volume_slider.value = value
	sound_volume_value.text = str(value)


func _on_music_volume_slider_value_changed(value: float) -> void:
	update_music_volume_slider(value)


func _on_music_volume_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		var value = music_volume_slider.value
		systems_manager.change_option(Enums.OPTION.audio_music_volume, value)
		update_music_volume_slider(value)


func _on_sound_volume_slider_value_changed(value: float) -> void:
	update_sound_volume_slider(value)


func _on_sound_volume_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		var value = sound_volume_slider.value
		systems_manager.change_option(Enums.OPTION.audio_sound_volume, value)
		update_sound_volume_slider(value)


func _on_ok_button_pressed() -> void:
	app_node.systems_manager.play_sound_file(Globals.menu_click_sound)
	systems_manager.save_options()
	app_node.ui_manager.change_ui(Enums.UI.ui_main_menu)
