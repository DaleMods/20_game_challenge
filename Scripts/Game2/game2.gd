extends Control

@export var Ball: CharacterBody2D

@onready var brick_spawner: BrickSpawner = $BrickSpawner
@onready var player: CharacterBody2D = $Player


var score = 0
var lives = 0

var game_started = false
var game_demo = false


func _ready() -> void:
	brick_spawner.brick_destroyed.connect(on_brick_destroyed)
	brick_spawner.level_completed.connect(on_level_completed)
	get_node("GameOver").hide()
	get_node("Instructions").show()
	get_node("PressSpace").show()
	game_demo = true
	Ball.set_demo_mode(game_demo)


func _process(_delta: float) -> void:
	if game_demo == true:
		player.demo_position_set(Ball.position.x)
	else:
		player.demo_position_set(0)
	if Input.is_action_just_pressed("Escape"):
		get_tree().change_scene_to_file("res://Scenes/menu_system.tscn")
	if Input.is_action_just_pressed("Space"):
		if game_started == false:
			new_game()


func _on_out_of_bounds_body_entered(body: Node2D) -> void:
	if body == Ball:
		if game_demo == true:
			Ball.reset_ball()
		else:
			lives -= 1
			update_lives_label()
			if lives > 0:
				Ball.reset_ball()
			elif lives < 1:
				end_game()


func on_brick_destroyed():
	if not game_demo == true:
		score += 10
		update_score_label()


func update_score_label():
	get_node("Score").text = "Score: " + str(score)


func update_lives_label():
	get_node("Lives").text = "Lives: " + str(lives)


func new_game():
	score = 0
	lives = 3
	update_score_label()
	update_lives_label()
	game_started = true
	game_demo = false
	Ball.set_demo_mode(game_demo)
	get_node("GameOver").hide()
	get_node("Instructions").hide()
	get_node("PressSpace").hide()
	brick_spawner.reset_new_game()


func end_game():
	Ball.reset_ball()
	game_started = false
	game_demo = true
	Ball.set_demo_mode(game_demo)
	get_node("GameOver").show()
	get_node("Instructions").hide()
	get_node("PressSpace").show()


func on_level_completed():
	score += 100
	update_score_label()
