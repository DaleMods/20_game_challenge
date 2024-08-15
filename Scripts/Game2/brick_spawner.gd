extends Node

class_name BrickSpawner

const COLUMNS = 1
const ROWS = 1

@onready var ball: CharacterBody2D = $"../Ball"

@export var brick_scene: PackedScene
@export var margin: Vector2 = Vector2(2,2)
@export var spawn_start: Marker2D

signal brick_destroyed
signal level_completed

var brick_count = 0
var current_level = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_from_defintion(LevelDefinitions.get_level(current_level))


func spawn_from_defintion(level_definition):
	var test_brick = brick_scene.instantiate() as Brick
	add_child(test_brick)
	var brick_size = test_brick.get_size()
	test_brick.queue_free()
	
	var rows = level_definition.size()
	var columns = level_definition[0].size()
	
	
	var row_width = brick_size.x * columns + margin.x * (columns - 1)
	var spawn_position_x = spawn_start.position.x + (-row_width + brick_size.x + margin.x) / 2 
	var spawn_position_y = spawn_start.position.y
	
	for i in rows:
		for j in columns:
			if level_definition[i][j] == 0:
				continue
				
			var brick = brick_scene.instantiate() as Brick
			add_child(brick)
			brick.set_level(level_definition[i][j])
			var x = spawn_position_x + j * (margin.x + brick.get_size().x )
			var y = spawn_position_y + i * (margin.y + brick.get_size().y )
			brick.set_position(Vector2(x, y))
			brick.brick_destroyed.connect(on_brick_destroyed)
			brick_count += 1


func on_brick_destroyed():
	brick_count -= 1
	brick_destroyed.emit()
	if brick_count == 0:
		ball.reset_ball()
		current_level += 1
		spawn_from_defintion(LevelDefinitions.get_level(current_level))
		level_completed.emit()


func reset_new_game():
	brick_count = 0
	current_level = 0
	ball.reset_ball()
	for brick in get_children():
		brick.queue_free()
	spawn_from_defintion(LevelDefinitions.get_level(current_level))
