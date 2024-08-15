class_name ghost_inky
extends CharacterBody2D

signal got_player
signal got_eaten

@onready var anim_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var left_cast: RayCast2D = $LeftCast
@onready var right_cast: RayCast2D = $RightCast
@onready var up_cast: RayCast2D = $UpCast
@onready var down_cast: RayCast2D = $DownCast
@onready var eyes_right: Sprite2D = $eyes_right
@onready var eyes_left: Sprite2D = $eyes_left
@onready var eyes_up: Sprite2D = $eyes_up
@onready var eyes_down: Sprite2D = $eyes_down

var speed = 80.0
var move_direction = Vector2.UP
var prev_direction = Vector2.ZERO
var prev_position = Vector2.ZERO
var hold_position = true
var is_at_intersection := false
var intersection_pos := Vector2.ZERO
var is_in_ghost_house = false
var ghost_house_door = Vector2(400,240)
var start_cooldown = 6.0
var is_chasing = false
var is_blue = false
var is_blink_blue = false
var is_eyes = false
var eyes_cooldown = 0.0
var game: Node2D


func _ready() -> void:
	game = get_node("/root/Game5")


func _physics_process(delta: float) -> void:
	if hold_position:
		return
	
	if start_cooldown > 0:
		start_cooldown -= delta
		if start_cooldown < 0:
			start_cooldown = 0
		return
	
	if is_eyes and hold_position == false:
		eyes_cooldown -= delta
		if prev_position == global_position or eyes_cooldown <= 0:
			eyes_cooldown = 0
			global_position = ghost_house_door
	prev_position = global_position
	
	get_next_move_direction()
	
	if is_blue or is_blink_blue:
		velocity = move_direction * (speed / 2)
	elif is_eyes:
		velocity = move_direction * (speed * 1.2)
	else:
		velocity = move_direction * speed
	
	if is_blue:
		anim_sprite_2d.play("blue")
	elif is_blink_blue:
		anim_sprite_2d.play("blink_blue")
	elif is_eyes:
		anim_sprite_2d.hide()
		if velocity.x < 0 and prev_direction != move_direction:
			eyes_left.show()
			eyes_right.hide()
			eyes_up.hide()
			eyes_down.hide()
		elif velocity.x > 0 and prev_direction != move_direction:
			eyes_left.hide()
			eyes_right.show()
			eyes_up.hide()
			eyes_down.hide()
		elif velocity.y < 0 and prev_direction != move_direction:
			eyes_left.hide()
			eyes_right.hide()
			eyes_up.show()
			eyes_down.hide()
		elif velocity.y > 0 and prev_direction != move_direction:
			eyes_left.hide()
			eyes_right.hide()
			eyes_up.hide()
			eyes_down.show()
	elif velocity.x < 0 and prev_direction != move_direction:
		anim_sprite_2d.play("left")
	elif velocity.x > 0 and prev_direction != move_direction:
		anim_sprite_2d.play("right")
	elif velocity.y < 0 and prev_direction != move_direction:
		anim_sprite_2d.play("up")
	elif velocity.y > 0 and prev_direction != move_direction:
		anim_sprite_2d.play("down")
	
	move_and_slide()
	prev_direction = move_direction


func start_game():
	hold_position = false


func get_next_move_direction():
	if is_in_ghost_house:
		get_out_of_ghost_house()
		return
	
	if is_eyes:
		am_i_at_ghost_door()
	
	if is_blue or is_blink_blue or game.game_state == 0:
		move_direction = get_frightened_direction()
	else:
		move_direction = get_direction()


func get_scatter_position():
	return game.level.get_inky_scatter()


func get_chase_position():
	return game.players.where_is_player()


func get_direction():
	var target_pos = get_scatter_position()
	
	if is_chasing:
		var blinky_pos = game.ghosts.get_blinky_position()
		if blinky_pos == Vector2.ZERO:
			blinky_pos = get_scatter_position()
		var player_dir = game.players.what_direction_is_player()
		
		# This is the original Pacman game's overflow calculation
		if player_dir == Vector2.UP:
			player_dir = Vector2(-1,-1)
		
		var player_target_pos = get_chase_position() + (player_dir * 40)
		var blinky_player_vector = player_target_pos - blinky_pos
		target_pos = player_target_pos + blinky_player_vector
	if is_eyes:
		target_pos = ghost_house_door
	
	var distance = (Vector2(0, 0)).distance_to(Vector2(800, 600))
	var next_move_direction = move_direction
	if can_i_turn():
		if (position + Vector2(-20, 0)).distance_to(target_pos) < distance and left_cast.is_colliding() == false and move_direction != Vector2.RIGHT:
			distance = (position + Vector2(-20, 0)).distance_to(target_pos)
			next_move_direction = Vector2.LEFT
		if (position + Vector2(20, 0)).distance_to(target_pos) < distance and right_cast.is_colliding() == false and move_direction != Vector2.LEFT:
			distance = (position + Vector2(20, 0)).distance_to(target_pos)
			next_move_direction = Vector2.RIGHT
		if (position + Vector2(0, -20)).distance_to(target_pos) < distance and up_cast.is_colliding() == false and move_direction != Vector2.DOWN:
			distance = (position + Vector2(0, -20)).distance_to(target_pos)
			next_move_direction = Vector2.UP
		if (position + Vector2(0, 20)).distance_to(target_pos) < distance and down_cast.is_colliding() == false and move_direction != Vector2.UP and am_i_at_ghost_door() == false:
			distance = (position + Vector2(0, 20)).distance_to(target_pos)
			next_move_direction = Vector2.DOWN
	
	return next_move_direction


func get_out_of_ghost_house():
	if global_position.x < 395:
		move_direction = Vector2.RIGHT
		return
	if global_position.x > 405:
		move_direction = Vector2.LEFT
		return
	if global_position.y <= 280:
		global_position = ghost_house_door
		is_in_ghost_house = false
		return
	move_direction = Vector2.UP
	return


func am_i_at_ghost_door():
	if (global_position.x - ghost_house_door.x) >= -5 and (global_position.x - ghost_house_door.x) <= 5 and (global_position.y - ghost_house_door.y) >= -5 and (global_position.y - ghost_house_door.y) <= 5:
		global_position = Vector2(400,300)
		anim_sprite_2d.show()
		is_eyes = false
		is_blue = false
		is_blink_blue = false
		is_in_ghost_house = true
		eyes_left.hide()
		eyes_right.hide()
		eyes_up.hide()
		eyes_down.hide()
		return true
	return false


func can_i_turn():
	if is_at_intersection == false:
		return false
	if (global_position.x - intersection_pos.x) < -2.5 or (global_position.x - intersection_pos.x) > 2.5:
		return false
	if (global_position.y - intersection_pos.y) < -2.5 or (global_position.y - intersection_pos.y) > 2.5:
		return false
	return true


func _on_area_2d_body_entered(body: Node2D) -> void:
	if is_eyes:
		return
	if body is Game5Player:
		if is_blue or is_blink_blue:
			emit_signal("got_eaten", global_position)
			eyes_cooldown = 5.0
			is_eyes = true
			is_blue = false
			is_blink_blue = false
		else:
			hold_position = true
			var player = body
			emit_signal("got_player")
			player.kill_player()


func at_intersection(pos):
	is_at_intersection = true
	intersection_pos = pos


func not_at_intersection():
	is_at_intersection = false
	intersection_pos = Vector2.ZERO


func level_complete():
	hold_position = true


func switch_chase_scatter_state(state):
	is_chasing = state


func is_ghost():
	return true


func set_frightened():
	if is_eyes:
		return
	is_blue = true
	if move_direction == Vector2.LEFT:
		move_direction = Vector2.RIGHT
	elif move_direction == Vector2.RIGHT:
		move_direction = Vector2.LEFT
	elif move_direction == Vector2.UP:
		move_direction = Vector2.DOWN
	elif move_direction == Vector2.DOWN:
		move_direction = Vector2.UP


func get_frightened_direction():
	var next_move_direction = move_direction
	var valid_directions = []
	if can_i_turn():
		if left_cast.is_colliding() == false and move_direction != Vector2.RIGHT:
			valid_directions.append(Vector2.LEFT)
		if right_cast.is_colliding() == false and move_direction != Vector2.LEFT:
			valid_directions.append(Vector2.RIGHT)
		if up_cast.is_colliding() == false and move_direction != Vector2.DOWN:
			valid_directions.append(Vector2.UP)
		if down_cast.is_colliding() == false and move_direction != Vector2.UP:
			valid_directions.append(Vector2.DOWN)
	
	if valid_directions.size() > 0:
		next_move_direction = valid_directions.pick_random()
	
	return next_move_direction
