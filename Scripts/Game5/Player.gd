class_name Game5Player
extends CharacterBody2D

signal player_is_dead

@onready var sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var death_animation: AnimatedSprite2D = $DeathAnimation
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var chomp: AudioStreamPlayer2D = $Chomp
@onready var death_sound: AudioStreamPlayer2D = $DeathSound

var speed := 80.0
var move_direction := Vector2.ZERO
var next_move_direction := Vector2.ZERO
var shape_query := PhysicsShapeQueryParameters2D.new()
var is_at_intersection := false
var intersection_pos := Vector2.ZERO
var previous_pos := Vector2.ZERO
var hold_position = false
var game: Node2D


func _ready() -> void:
	game = get_node("/root/Game5")
	shape_query.shape = collision_shape_2d.shape
	shape_query.collision_mask = 2


func _physics_process(delta: float) -> void:
	if hold_position == true:
		velocity = Vector2.ZERO
		return
	
	if Input.is_action_just_pressed("Z"):
		kill_player()
	
	get_input()
	if move_direction == Vector2.ZERO:
		move_direction = next_move_direction
	if can_move_in_direction(next_move_direction, delta):
		move_direction = next_move_direction
	
	velocity = move_direction * speed
	
	if velocity.x < 0:
		sprite_2d.rotation_degrees = 180
	elif velocity.x > 0:
		sprite_2d.rotation_degrees = 0
	elif velocity.y < 0:
		sprite_2d.rotation_degrees = 270
	elif velocity.y > 0:
		sprite_2d.rotation_degrees = 90
	move_and_slide()
	
	if previous_pos == global_position:
		sprite_2d.pause()
	else:
		sprite_2d.play("default")
	previous_pos = global_position


func get_input():
	if Input.is_action_pressed("A"):
		next_move_direction = Vector2.LEFT
	elif Input.is_action_pressed("D"):
		next_move_direction = Vector2.RIGHT
	elif Input.is_action_pressed("W"):
		next_move_direction = Vector2.UP
	elif Input.is_action_pressed("S"):
		next_move_direction = Vector2.DOWN

func can_move_in_direction(dir: Vector2, delta: float):
	if move_direction == Vector2.LEFT and next_move_direction == Vector2.RIGHT:
		return true
	if move_direction == Vector2.RIGHT and next_move_direction == Vector2.LEFT:
		return true
	if move_direction == Vector2.UP and next_move_direction == Vector2.DOWN:
		return true
	if move_direction == Vector2.DOWN and next_move_direction == Vector2.UP:
		return true
	
	if is_at_intersection == false:
		return false
	
	if (global_position.x - intersection_pos.x) < -5 or (global_position.x - intersection_pos.x) > 5:
		return false
	if (global_position.y - intersection_pos.y) < -5 or (global_position.y - intersection_pos.y) > 5:
		return false
	
	shape_query.transform = global_transform.translated(dir * speed * delta * 2)
	var result = get_world_2d().direct_space_state.intersect_shape(shape_query)
	return result.size() == 0


func eat_pellet():
	chomp.play()
	game.pellets_eaten += 1
	game.add_score(10, Vector2.ZERO)


func eat_power_pellet():
	chomp.play()
	game.add_score(50, Vector2.ZERO)
	game.ghosts.power_pellet_eaten()


func at_intersection(pos):
	is_at_intersection = true
	intersection_pos = pos


func not_at_intersection():
	is_at_intersection = false
	intersection_pos = Vector2.ZERO


func level_complete():
	hold_position = true


func kill_player():
	hold_position = true
	sprite_2d.hide()
	death_animation.show()
	death_animation.play()
	death_sound.play()
	await get_tree().create_timer(1.6).timeout
	death_animation.hide()
	emit_signal("player_is_dead")


func where_is_player():
	return position


func what_direction_is_player():
	return move_direction
