class_name Game6Croc
extends CharacterBody2D

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var hold_position = false
var mouth_open = false

# Body Attributes:
var can_climb = false
var can_kill_harry = true
var can_roll = false
var can_shrink_expand = false
var is_temp_safe = true
var is_treasure = false


func _physics_process(delta: float) -> void:
	if hold_position:
		return
	
	if mouth_open:
		can_kill_harry = true
	else:
		can_kill_harry = false
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	do_animation()
	
	if not is_on_floor():
		move_and_slide()


func do_animation():
	if mouth_open:
		$AnimatedSprite2D.play("open")
	else:
		$AnimatedSprite2D.play("closed")


func set_hold_position(state):
	hold_position = state


func change_mouth():
	mouth_open = !mouth_open
