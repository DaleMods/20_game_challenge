extends Marker2D

@onready var world: Node2D = $"../World/Enemies"
@export var river_spawner: Marker2D

var spawn_internal_min: float = 3
var spawn_internal_max: float = 5

var enemy_objects: Array[PackedScene] = [
		preload("res://Scenes/Game3/bf_109.tscn"),
		preload("res://Scenes/Game3/small_ship.tscn"),
		preload("res://Scenes/Game3/big_ship.tscn"),
	]

func _ready() -> void:
	get_tree().create_timer(randf_range(spawn_internal_min, spawn_internal_max)).timeout.connect(spawn_enemy)
#	spawn_enemy()


func spawn_enemy():
	var enemy_scene = enemy_objects.pick_random()
	var new_enemy = enemy_scene.instantiate()
	var spawn_range = get_current_spawn_range()
	var spawn_point = spawn_range.pick_random()
	new_enemy.position.x = randi_range(spawn_point.x, spawn_point.y)
	world.add_child(new_enemy)
	
	get_tree().create_timer(randf_range(spawn_internal_min, spawn_internal_max)).timeout.connect(spawn_enemy)



func get_current_spawn_range():
	var spawn_range = river_spawner.get_river_x_range()
	return spawn_range


func reset_spawner():
	for enemy in world.get_children():
		enemy.queue_free()
