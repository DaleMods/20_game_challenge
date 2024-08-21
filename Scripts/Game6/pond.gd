class_name Game6Pond
extends CharacterBody2D

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var hold_position = false
var do_flexing = true
var is_shrinking = true
var scale_amount = Vector2(0.05, 0.05)
var start_scale = Vector2(5.0, 5.0)
var start_position = Vector2(400, 362)

# Body Attributes:
var can_climb = false
var can_kill_harry = true
var can_roll = false
var can_shrink_expand = true
var is_temp_safe = false
var is_treasure = false


func _physics_process(_delta: float) -> void:
	if hold_position:
		return
	
#	if not is_on_floor():
#		velocity.y += gravity * delta
	
	if global_position != start_position:
		global_position = start_position
	
	if do_flexing:
		do_shrink_expand()
	
	move_and_slide()


func set_hold_position(state):
	hold_position = state


func do_shrink_expand():
	if is_shrinking:
		global_scale -= scale_amount
	else:
		global_scale += scale_amount
	if global_scale < Vector2(0.05, 0.05):
		is_shrinking = false
		global_scale = Vector2(0.5, 0.05)
	if global_scale >= start_scale:
		is_shrinking = true
		global_scale = start_scale


func disable_pond():
	hold_position = true
	visible = false
	$CollisionShape2D.disabled = true


func enable_pond(flexing):
	hold_position = false
	do_flexing = flexing
	visible = true
	$CollisionShape2D.disabled = false
