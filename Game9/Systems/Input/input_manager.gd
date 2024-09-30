class_name Game9InputManager
extends Node

signal key_pressed
signal key_released

var keys_down: Array = []


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed:
			keys_down.append(event.keycode)
			emit_signal("key_pressed", event.keycode)
		else:
			keys_down.erase(event.keycode)
			emit_signal("key_released", event.keycode)
