extends Control


func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_game_1_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Game1/arena.tscn")

func _on_game_2_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Game2/game.tscn")


func _on_game_3_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Game3/game3.tscn")


func _on_game_4_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Game4/game4.tscn")


func _on_game_5_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Game5/game5.tscn")
