extends Control


func _on_new_game_pressed() -> void:
	get_parent().do_new_game()


func _on_options_pressed() -> void:
	$"../OptionsMenu".visible = true
	$"../OptionsMenu".configure_options()



func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu_system.tscn")
