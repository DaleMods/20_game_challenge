extends Node

@onready var game_5: Node2D = $".."

var player_scene = preload("res://Scenes/Game5/player.tscn")

func spawn_player(level, active_level):
	if get_child_count() > 0:
		for child in get_children():
			child.queue_free()
	while level.get_child_count() == 0:
		await get_tree().create_timer(0.1).timeout
	if active_level.has_method("get_player_spawn"):
		var pos = active_level.get_player_spawn()
		var player = player_scene.instantiate()
		player.global_position = pos
		player.name = "Player"
		player.player_is_dead.connect(game_5.life_lost)
		call_deferred("add_child", player)


func end_game():
	if get_child_count() > 0:
		for child in get_children():
			child.queue_free()


func where_is_player():
	return get_child(0).where_is_player()


func what_direction_is_player():
	return get_child(0).what_direction_is_player()
