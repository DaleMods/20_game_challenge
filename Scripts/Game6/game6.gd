class_name Game6Game
extends Node2D

@onready var player_manager: Game6PlayerManager = $Player
@onready var room_manager: Game6RoomManager = $Room
@onready var room: Node2D = $Room/Room
@onready var time_label: Label = $UI/Time
@onready var timer: Timer = $Timer
@onready var press_space_label: Label = $UI/Panel/PressSpace
@onready var instructions_label: Label = $UI/Panel/Instructions
@onready var game_over_label: Label = $UI/GameOver
@onready var panel: Panel = $UI/Panel

var this_scene_loaded = false

# Game states:
# 0 - loading
# 1 - loaded
# 2 - playing
# 3 - end playing win or lose
var game_state = 0


func _ready() -> void:
	this_scene_loaded = true
	game_state = 1
	panel.visible = true
	press_space_label.visible = true
	instructions_label.visible = true
	game_over_label.visible = false


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Escape"):
		get_tree().change_scene_to_file("res://Scenes/menu_system.tscn")
		this_scene_loaded = false
		return
	
	if game_state < 3:
		if $Audio/ThemeMusic.playing == false:
			$Audio/ThemeMusic.play()
	
	if game_state == 1 or game_state == 3:
		if Input.is_action_just_pressed("Space"):
			new_game()
	
	if game_state == 2:
		var time: int = int(timer.time_left)
		time_label.text = "TIME: " + str(time)
		if room_manager.score <= 0:
			out_of_time()
	
	if game_state == 3:
		if $Audio/WinMusic.playing == false and $Audio/LoseMusic.playing == false:
			game_state = 1


func new_game():
	if $Audio/WinMusic.playing:
		$Audio/WinMusic.stop()
	if $Audio/LoseMusic.playing:
		$Audio/LoseMusic.stop()
	game_state = 2
	panel.visible = false
	press_space_label.visible = false
	instructions_label.visible = false
	game_over_label.visible = false
	room_manager.new_game()
	room.reached_end.connect(end_game_win)
	timer.wait_time = 1200
	timer.timeout.connect(out_of_time)
	timer.start()


func out_of_time():
	$Audio/LoseMusic.play()
	game_over_label.text = "GAME OVER\nYOU LOSE!"
	end_game()


func end_game_win():
	$Audio/WinMusic.play()
	game_over_label.text = "GAME OVER\nYOU WIN!"
	end_game()


func end_game():
	$Audio/ThemeMusic.stop()
	game_state = 3
	timer.stop()
	player_manager.end_game()
	panel.visible = true
	press_space_label.visible = true
	instructions_label.visible = true
	game_over_label.visible = true
