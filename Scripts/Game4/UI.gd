extends Control

var uilife_scene = preload("res://Scenes/Game4/ui_life.tscn")

@onready var score = $Score:
	set(value):
		score.text = "SCORE: " + str(value)

@onready var level = $Level:
	set(value):
		level.text = "LEVEL: " + str(value)

@onready var lives = $Lives

@onready var teleport = $Teleport:
	set(value):
		teleport.text = "TELEPORT: " + str(value)

func init_lives(amount):
	for ul in lives.get_children():
		ul.queue_free()
	for i in amount:
		var ul = uilife_scene.instantiate()
		lives.add_child(ul)
