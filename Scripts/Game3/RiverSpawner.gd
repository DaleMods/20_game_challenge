extends Marker2D

@onready var world: Node2D = $"../World"

var current_segment

var river_objects: Array[PackedScene] = [
		preload("res://Scenes/Game3/river_straight.tscn"),
		preload("res://Scenes/Game3/river_narrow.tscn"),
		preload("res://Scenes/Game3/river_split.tscn"),
	]


func _ready() -> void:
	var river_scene = river_objects[0]
	var new_river = river_scene.instantiate()
	new_river.position = Vector2(0, 600)
	world.add_child(new_river)
	current_segment = 0


func spawn_river(segment: int):
	var river_scene = river_objects[segment]
	var new_river = river_scene.instantiate()
	new_river.position = Vector2(0, 0)
	world.add_child(new_river)
	current_segment = segment


func notify_spawn_new_segment():
	spawn_river(randi_range(0, river_objects.size() - 1))


func get_river_x_range():
	var x_range = [Vector2(0,0), Vector2(0,0)]
	if current_segment == 0:
		x_range[0].x = 150
		x_range[0].y = 650
		x_range[1].x = 150
		x_range[1].y = 650
	if current_segment == 1:
		x_range[0].x = 300
		x_range[0].y = 500
		x_range[1].x = 300
		x_range[1].y = 500
	if current_segment == 2:
		x_range[0].x = 150
		x_range[0].y = 350
		x_range[1].x = 450
		x_range[1].y = 650
	
	return x_range
