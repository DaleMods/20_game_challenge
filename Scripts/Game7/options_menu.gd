extends Control

@onready var music_on: CheckButton = $Panel/VBoxContainer/HBoxContainer/MusicOn
@onready var sounds_on: CheckButton = $Panel/VBoxContainer/HBoxContainer2/SoundsOn
@onready var texture_button: TextureButton = $Panel/VBoxContainer/TextureButton

func _ready() -> void:
	visible = false


func configure_options():
	music_on.button_pressed = $"..".music_on
	sounds_on.button_pressed = $"..".sounds_on


func _on_texture_button_pressed() -> void:
	visible = false


func _on_music_on_toggled(_toggled_on: bool) -> void:
	$"..".music_on = music_on.button_pressed


func _on_sounds_on_toggled(_toggled_on: bool) -> void:
	$"..".sounds_on = sounds_on.button_pressed
