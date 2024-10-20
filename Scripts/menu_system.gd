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


func _on_game_6_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Game6/game6.tscn")


func _on_game_7_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Game7/game7.tscn")


func _on_game_8_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Game8/game8.tscn")


func _on_game_9_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Game9/game9.tscn")


func _on_game_10_button_pressed() -> void:
	$DaleCraftMessage.visible = true


func _on_continue_pressed() -> void:
	$DaleCraftMessage.visible = false
	get_tree().change_scene_to_file("res://Game10/game_10.tscn")
