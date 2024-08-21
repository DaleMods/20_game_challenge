class_name Game6Snek
extends CharacterBody2D

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var hold_position = false

# Body Attributes:
var can_climb = false
var can_kill_harry = true
var can_roll = false
var can_shrink_expand = false
var is_temp_safe = false
var is_treasure = false


func _physics_process(delta: float) -> void:
	if hold_position:
		return
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	move_and_slide()


func set_hold_position(state):
	hold_position = state
