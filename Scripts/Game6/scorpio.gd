class_name Game6Scorpio
extends CharacterBody2D

var speed = 50.0
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var hold_position = false
var next_direction = Vector2.ZERO

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
	
	set_next_direction()
	
	if next_direction != Vector2.ZERO:
		velocity.x = next_direction.x * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	do_animation()
	move_and_slide()


func set_next_direction():
	var player_position = get_parent().where_is_player()
	if player_position.x < global_position.x:
		next_direction = Vector2.LEFT
	elif player_position.x > global_position.x:
		next_direction = Vector2.RIGHT


func do_animation():
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = false


func set_hold_position(state):
	hold_position = state
