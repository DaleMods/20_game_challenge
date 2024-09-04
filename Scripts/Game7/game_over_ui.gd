extends Control

func _ready() -> void:
	visible = false


func show_game_over(player_num):
	visible = true
	$VBoxContainer/Winner.visible = true
	match player_num:
		0:
			$VBoxContainer/Winner.visible = false
		1:
			$VBoxContainer/Winner.text = "PLAYER 1 WINS!"
		2:
			$VBoxContainer/Winner.text = "PLAYER 2 WINS!"


func hide_game_over():
	visible = false


func _on_texture_button_pressed() -> void:
	get_parent().do_menu()
