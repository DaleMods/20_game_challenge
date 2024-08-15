extends Node

var fruit_scene = preload("res://Scenes/Game5/fruit.tscn")

func spawn_fruit(level):
	if get_child_count() > 0:
		return
	var fruit_to_place = fruit_scene.instantiate()
	fruit_to_place.position = Vector2(400,340)
	add_child(fruit_to_place)
	fruit_to_place.set_fruit(level)
