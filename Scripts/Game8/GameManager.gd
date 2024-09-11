extends Node3D

# Game States:
# 0 - Loading
# 1 - Main Menu
# 5 - Level
# 6 - Spawn Boss
# 7 - Fighting Boss
var game_state = 0:
	set(value):
		game_state = value

var score := 0:
	set(value):
		score = value
		$UI/Score.text = "Score: " + str(score)


func _ready() -> void:
	$UI/BossBox.visible = false
	game_state = 1


func _physics_process(_delta: float) -> void:
	if game_state >= 6 and game_state <= 7:
		$UI/BossBox.visible = true


func new_game():
	$UI.visible = true
	$EndGame.visible = false
	$EndLevel.visible = false
	game_state = 5
	score = 0


func end_game():
	$UI.visible = true
	$EndGame.visible = true
	$EndLevel.visible = false


func add_score(amount):
	score = score + amount


func set_player_shield(shield):
	$UI/PlayerBox/ProgressBar.value = shield


func set_boss_shield(shield):
	$UI/BossBox/ProgressBar.value = shield


func _on_texture_button_pressed() -> void:
	get_parent().show_menu()
	queue_free()


func next_level():
	$EndLevel.visible = true


func _on_ok_button_pressed() -> void:
	game_state = 5
	$UI/BossBox.visible = false
	$EndLevel.visible = false
	$EnemySpawner.level_time = 0.0
	set_boss_shield(100)
