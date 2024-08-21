class_name Game6PlayerManager
extends Node

signal player_killed
signal player_death_completed
signal player_treasure_got

@onready var room: Node2D = $"../Room/Room"

var harry_scene = preload("res://Scenes/Game6/harry.tscn")
var harry_node: CharacterBody2D = null


func spawn_harry(harry_spawn_pos):
	if get_child_count() > 0:
		for child in get_children():
			child.queue_free()
	var harry = harry_scene.instantiate()
	harry.name = "Harry"
	harry.global_position = harry_spawn_pos
	add_child(harry)
	harry_node = harry
	harry_node.harry_killed.connect(kill_harry)
	harry_node.death_completed.connect(death_completed)
	harry_node.treasure_got.connect(treasure_got)
	
	room.exit_top_left.connect(on_exit_top_left)
	room.exit_top_right.connect(on_exit_top_right)
	room.exit_bottom_left.connect(on_exit_bottom_left)
	room.exit_bottom_right.connect(on_exit_bottom_right)
	
	harry_node.playing = true


func where_is_player():
	if harry_node != null:
		return harry_node.global_position
	return Vector2.ZERO


func kill_harry():
	emit_signal("player_killed")


func death_completed():
	emit_signal("player_death_completed")


func treasure_got():
	emit_signal("player_treasure_got")


func reset_player(reset_position):
	if harry_node != null:
		harry_node.reset_harry(reset_position)


func on_exit_top_left():
	harry_node.global_position.x = 750


func on_exit_top_right():
	harry_node.global_position.x = 50


func on_exit_bottom_left():
	harry_node.global_position.x = 750


func on_exit_bottom_right():
	harry_node.global_position.x = 50


func end_game():
	harry_node.end_game()
