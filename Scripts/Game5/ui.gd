extends Control

var uilife_scene = preload("res://Scenes/Game5/pacman.tscn")
var score_label_scene = preload("res://Scenes/Game5/score_label.tscn")

@onready var game: Node2D = $".."

@onready var score = $Score:
	set(value):
		score.text = "SCORE: " + str(value)

@onready var lives = $Lives

func init_lives(amount):
	for ul in lives.get_children():
		ul.queue_free()
	await get_tree().create_timer(0.1).timeout
	for i in amount:
		var ul = uilife_scene.instantiate()
		lives.add_child(ul)


func do_score_label(value, pos):
	var score_label = score_label_scene.instantiate()
	score_label.get_node("Label").global_position = (pos + Vector2(-50,-12.5))
	score_label.get_node("Label").text = str(value)
	game.add_child(score_label)
	await get_tree().create_timer(1).timeout
	score_label.queue_free()
