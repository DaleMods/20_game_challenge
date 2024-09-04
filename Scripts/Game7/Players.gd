extends Node

var player_scene = preload("res://Scenes/Game7/player.tscn")
var current_player = 0
var players: Array
var player1_spawn = Vector2(50, 200)
var player2_spawn = Vector2(750, 200)
var end_game = false

func setup_new_players():
	for child in get_children():
		child.queue_free()
	players = []
	var player1 = player_scene.instantiate()
	player1.global_position = player1_spawn
	player1.name = "Player1"
	add_child(player1)
	player1.configure_player(1, false, true)
	players.append(player1)
	var player2 = player_scene.instantiate()
	player2.global_position = player2_spawn
	player2.name = "Player2"
	add_child(player2)
	player2.configure_player(2, true, false)
	players.append(player2)
	current_player = 0
	end_game = false
	$"../GameUI".new_game()


func player_hit():
	end_game = true
	var exploding_player = current_player + 1
	if exploding_player >= 2:
		exploding_player = 0
	players[exploding_player].explode()
	await get_tree().create_timer(3.5).timeout
	$"..".do_game_over(current_player + 1)
	for child in get_children():
		child.queue_free()


func next_player():
	if not end_game:
		players[current_player].is_active = false
		current_player += 1
		if current_player >= 2:
			current_player = 0
		var player = players[current_player]
		player.fired_this_round = false
		player.ai.done_calculating = false
		$"../GameUI".show_player(current_player + 1)


func ui_finished():
	players[current_player].is_active = true


func get_wind_speed():
	return $"../Terrain".wind_speed


func get_wind_direction():
	return $"../Terrain".wind_direction
