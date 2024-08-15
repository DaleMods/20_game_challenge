extends Control

@onready var game_over_label: Label = $GameOverLabel
@onready var press_space_label: Label = $PressSpaceLabel
@onready var instructions_label: Label = $InstructionsLabel
@onready var info: Label = $Info

var game_playing = false
var total_score = 0

func _ready() -> void:
	press_space_label.show()
	game_over_label.hide()
	instructions_label.hide()
	info.show()
	game_playing = false


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Space") and game_playing == false:
		new_game()
	
	if Input.is_action_just_pressed("Escape"):
		get_tree().change_scene_to_file("res://Scenes/menu_system.tscn")
	
	if Input.is_action_just_pressed("I") and game_playing == false:
		instructions_label.visible = !instructions_label.visible
	
	if get_node("AudioStreamPlayer").playing == false:
		get_node("AudioStreamPlayer").play()


func _on_player_game_ended() -> void:
	game_over_label.show()
	press_space_label.show()
	instructions_label.hide()
	info.show()
	game_playing = false
	get_node("Player").set_game_playing(false)


func new_game():
	total_score = 0
	press_space_label.hide()
	game_over_label.hide()
	instructions_label.hide()
	info.hide()
	game_playing = true
	get_node("Player").set_game_playing(true)
	get_node("Player").position = Vector2(400,500)
	get_node("EnemySpawner1").reset_spawner()


func increase_score(score):
	total_score += score
	get_node("Score").text = "Score: " + str(total_score)
