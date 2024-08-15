extends Control

@export var Ball: CharacterBody2D

var player1_score = 0
var player2_score = 0
var win_score = 3
var delay = 0

# game_states:
# 0 - Demo mode "Press key to start"
# 1 - Game
# 2 - Game end 
var game_state = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_state = 0
	delay = 1
	get_node("PressKeyToStart").show()
	get_node("WinnerText").hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Escape"):
		get_tree().change_scene_to_file("res://Scenes/menu_system.tscn")
	if delay > 0:
		delay = delay - delta
	if delay < 0:
		Ball.start_ball()
		delay = 0
	if game_state == 0:
		if Input.is_action_just_pressed("Space"):
			do_start_game()


func _on_left_win_zone_body_entered(body: Node2D) -> void:
	if body == Ball:
		get_node("Score").play()
		player2_score = player2_score + 1
		update_scores()
		check_game_over()


func _on_right_win_zone_body_entered(body: Node2D) -> void:
	if body == Ball:
		get_node("Score").play()
		player1_score = player1_score + 1
		update_scores()
		check_game_over()


func check_game_over():
	var winner = false
	if player1_score >= win_score:
		winner = true
		do_win(true)
	if player2_score >= win_score:
		winner = true
		do_win(false)
	if winner == false:
		delay = 2


func do_win(player1: bool):
	var string = ""
	if player1:
		string = "PLAYER 1 WINS!"
	else:
		string = "PLAYER 2 WINS!"
	get_node("WinnerText").text = string
	get_node("WinnerText").show()
	get_node("PressKeyToStart").show()
	delay = 3
	game_state = 0


func get_game_state():
	return game_state


func do_start_game():
	game_state = 1
	delay = 2
	get_node("PressKeyToStart").hide()
	get_node("WinnerText").hide()
	player1_score = 0
	player2_score = 0
	update_scores()
	Ball.reset()


func update_scores():
	get_node("Player1Score").text = "Player 1: " + str(player1_score)
	get_node("Player2Score").text = "Player 2: " + str(player2_score)

