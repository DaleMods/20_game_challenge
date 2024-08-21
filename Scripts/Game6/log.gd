class_name Game6Log
extends CharacterBody2D

var speed = 200
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var hold_position = false

# Body Attributes:
var can_climb = false
var can_kill_harry = true
var can_roll = true
var can_shrink_expand = false
var is_temp_safe = false
var is_treasure = false


func _physics_process(_delta: float) -> void:
	if hold_position:
		return
	
#	if not is_on_floor():
#		velocity.y += gravity * delta
	
	if can_roll == false:
		if $AnimatedSprite2D.is_playing():
			$AnimatedSprite2D.stop()
	else:
		velocity.x = -1 * speed
		if global_position.x < -10:
			global_position.x = 810
	
	move_and_slide()


func set_hold_position(state):
	hold_position = state
