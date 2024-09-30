class_name Game9World
extends Node3D

const Globals = preload("res://Game9/Systems/globals.gd")

var car_scene = preload("res://Game9/Game/Cars/Nissan/nissan.tscn")
var track1_scene = preload("res://Game9/Game/Tracks/Track1/track_1.tscn")
var track2_scene = preload("res://Game9/Game/Tracks/Track2/track_2.tscn")
var track3_scene = preload("res://Game9/Game/Tracks/Track3/track_3.tscn")
var track4_scene = preload("res://Game9/Game/Tracks/Track4/track_4.tscn")
var track5_scene = preload("res://Game9/Game/Tracks/Track5/track_5.tscn")

var tracks: Array = [track1_scene, track2_scene, track3_scene, track4_scene, track5_scene]
var players: Array = []
var player_laps: Array = []
var total_laps = 0
var current_track: Node
var app_node: Node
var race_started = false
var race_ended = false


func _ready():
	app_node = get_node(Globals.app_node_path)


func _physics_process(_delta):
	if race_started:
		var speed = players[0].speed_kmh
		app_node.ui_manager.game_ui.speed = speed
		
		if race_ended == false:
			calculate_player_position()


func calculate_player_position():
	var car_position = 1
	var player0_lap_percent = current_track.player_0_follow.progress_ratio + player_laps[0]
	if player_laps.size() > 1:
		var player1_lap_percent = current_track.player_1_follow.progress_ratio + player_laps[1]
		if player0_lap_percent < player1_lap_percent:
			car_position += 1
	if player_laps.size() > 2:
		var player2_lap_percent = current_track.player_2_follow.progress_ratio + player_laps[2]
		if player0_lap_percent < player2_lap_percent:
			car_position += 1
	if player_laps.size() > 3:
		var player3_lap_percent = current_track.player_3_follow.progress_ratio + player_laps[3]
		if player0_lap_percent < player3_lap_percent:
			car_position += 1
	
	app_node.ui_manager.game_ui.car_position = car_position


func new_game(track_num, num_players, num_laps):
	var track = tracks[track_num].instantiate()
	track.player_lap.connect(on_player_lap)
	current_track = track
	add_child(track)
	add_players(num_players)
	total_laps = num_laps
	app_node.ui_manager.game_ui.total_laps = total_laps
	app_node.ui_manager.game_ui.total_positions = players.size()
	app_node.ui_manager.game_ui.car_position = 1
	app_node.ui_manager.game_ui.race_is_go.connect(on_race_is_go)
	app_node.ui_manager.game_ui.race_is_done.connect(on_race_is_done)
	app_node.ui_manager.game_ui.start_race()
	players[0].setup_player_camera()


func add_players(num_players):
	for num in num_players:
		var player = car_scene.instantiate()
		player.name = "Player" + str(num)
		add_child(player)
		player.global_position = current_track.get_node("Player" + str(num) + "Start").global_position
		player.global_rotation = current_track.get_node("Player" + str(num) + "Start").global_rotation
		player.player_num = num
		player_laps.append(1)
		players.append(player)


func on_player_lap(body):
	if race_ended == false:
		player_laps[body.player_num] += 1
		app_node.ui_manager.game_ui.lap = player_laps[body.player_num]
		app_node.ui_manager.game_ui.total_laps = total_laps
		if player_laps[body.player_num] > total_laps:
			race_ended = true


func on_race_is_go():
	race_started = true


func on_race_is_done():
	get_parent().race_ended = true
