class_name Game6RoomManager
extends Node

@onready var player: Game6PlayerManager = $"../Player"
@onready var room: Node2D = $Room
@onready var room_number: Label = $"../UI/RoomNumber"
@onready var score_label: Label = $"../UI/Score"

var harry_spawn_pos = Vector2(100,250)
var current_room = 0
var max_room = 255
var score = 1000

var room_main_enemy: Array
var room_ground: Array
var room_scorpion: Array
var room_walls: Array
var room_treasure: Array

var random = RandomNumberGenerator.new()


func _ready() -> void:
	random.randomize()
	current_room = 0
	score = 1000
	score_label.text = "SCORE: " + str(score)
	room.exit_top_left.connect(on_exit_top_left)
	room.exit_top_right.connect(on_exit_top_right)
	room.exit_bottom_left.connect(on_exit_bottom_left)
	room.exit_bottom_right.connect(on_exit_bottom_right)


func new_game():
	player.spawn_harry(harry_spawn_pos)
	player.player_killed.connect(player_killed)
	player.player_death_completed.connect(reset_room)
	player.player_treasure_got.connect(treasure_got)
	current_room = 0
	score = 1000
	score_label.text = "SCORE: " + str(score)
	create_rooms()
	setup_room()


func reset_room():
	player.reset_player(harry_spawn_pos)
	setup_room()


func get_harry_spawn():
	return harry_spawn_pos


func on_exit_top_left():
	change_room_left()


func on_exit_top_right():
	change_room_right()


func on_exit_bottom_left():
	change_room_left()


func on_exit_bottom_right():
	change_room_right()


func change_room_left():
	current_room -= 1
	if current_room < 0:
		current_room = 0
	setup_room()


func change_room_right():
	current_room += 1
	if current_room > 255:
		current_room = 255
	setup_room()


func setup_room():
	room_number.text = "ROOM: " + str(current_room)
	room.setup_room(room_main_enemy[current_room], room_ground[current_room], room_scorpion[current_room], room_walls[current_room], room_treasure[current_room])


func create_rooms():
	room_main_enemy.clear()
	room_ground.clear()
	room_scorpion.clear()
	room_walls.clear()
	room_treasure.clear()
	for num in range(0, (max_room + 1)):
		if num == 0:
			room_main_enemy.append(0)
			room_ground.append(2)
			room_scorpion.append(1)
			room_walls.append(4)
			room_treasure.append(0)
		elif num == 1:
			room_main_enemy.append(5)
			room_ground.append(0)
			room_scorpion.append(0)
			room_walls.append(0)
			room_treasure.append(5)
		elif num == max_room:
			room_main_enemy.append(0)
			room_ground.append(0)
			room_scorpion.append(1)
			room_walls.append(5)
			room_treasure.append(4)
		else:
			room_main_enemy.append(random.randi() % 9)
			room_ground.append(random.randi() % 8)
			room_scorpion.append(random.randi() % 2)
			room_walls.append(random.randi() % 3)
			if random.randi() % 100 < 5:
				room_treasure.append((random.randi() % 8) + 1)
			else:
				room_treasure.append(0)


func player_killed():
	score -= 500
	score_label.text = "SCORE: " + str(score)


func treasure_got():
	var treasure = room_treasure[current_room]
	match treasure:
		1:
			score += 2000
		2:
			score += 3000
		3:
			score += 4000
		4:
			score += 5000
		5:
			score += 2000
		6:
			score += 3000
		7:
			score += 4000
		8:
			score += 5000
	room_treasure[current_room] = 0
	room.remove_treasure()
	score_label.text = "SCORE: " + str(score)
