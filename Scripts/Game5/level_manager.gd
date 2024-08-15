extends Node

signal switch_chase_scatter

@onready var game_5: Node2D = $".."
@onready var ghosts: Node = $"../Ghosts"
@onready var players: Node = $"../Players"

var level_scenes = [
	preload("res://Scenes/Game5/level0.tscn"),
	preload("res://Scenes/Game5/level1.tscn"),
	preload("res://Scenes/Game5/level2.tscn"),
	preload("res://Scenes/Game5/level3.tscn"),
	preload("res://Scenes/Game5/level0.tscn"),
	preload("res://Scenes/Game5/level1.tscn"),
	preload("res://Scenes/Game5/level2.tscn"),
	preload("res://Scenes/Game5/level3.tscn"),
]

var level_offset = Vector2(190, 30)
var level: Node2D
var chase_scatter_state = 0
var chase_scatter_times = [7.0, 20.0, 7.0, 20.0, 5.0, 20.0, 5.0, 10000]
var chase_scatter_states = [false, true, false, true, false, true, false, true]

func load_level(level_num):
	if get_child_count() > 0:
		for child in get_children():
			child.queue_free()
	var level_scene = level_scenes[level_num].instantiate()
	level_scene.position = level_offset
	if switch_chase_scatter.is_connected(ghosts.switching_chase_scatter) == false:
		switch_chase_scatter.connect(ghosts.switching_chase_scatter)
	call_deferred("add_child", level_scene)
	level = level_scene
	return level_scene


func level_complete():
	if players.get_child_count() > 0:
		for child in players.get_children():
			child.level_complete()
	if ghosts.get_child_count() > 0:
		for child in ghosts.get_children():
			child.level_complete()


func start_game():
	chase_scatter_state = 0
	get_tree().create_timer(chase_scatter_times[chase_scatter_state]).timeout.connect(next_chase_scatter_state)


func next_chase_scatter_state():
	chase_scatter_state += 1
	if chase_scatter_state < chase_scatter_times.size():
		emit_signal("switch_chase_scatter", chase_scatter_states[chase_scatter_state])
		get_tree().create_timer(chase_scatter_times[chase_scatter_state]).timeout.connect(next_chase_scatter_state)
	else:
		emit_signal("switch_chase_scatter", true)


func reset_chase_scatter_state():
	chase_scatter_state = 0


func get_blinky_scatter():
	return level.get_blinky_scatter()


func get_pinky_scatter():
	return level.get_pinky_scatter()


func get_inky_scatter():
	return level.get_inky_scatter()


func get_clyde_scatter():
	return level.get_clyde_scatter()
