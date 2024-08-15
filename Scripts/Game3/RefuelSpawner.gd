extends Marker2D

@onready var world: Node2D = $"../World"
@export var river_spawner: Marker2D

var spawn_internal_min: float = 6
var spawn_internal_max: float = 12

func _ready() -> void:
	get_tree().create_timer(randf_range(spawn_internal_min, spawn_internal_max)).timeout.connect(spawn_fueler)


func spawn_fueler():
	var fueler_scene = preload("res://Scenes/Game3/fueler.tscn")
	var new_fueler = fueler_scene.instantiate()
	var spawn_range = get_current_spawn_range()
	var spawn_point = spawn_range.pick_random()
	new_fueler.position.x = randi_range(spawn_point.x, spawn_point.y)
	world.add_child(new_fueler)
	
	get_tree().create_timer(randf_range(spawn_internal_min, spawn_internal_max)).timeout.connect(spawn_fueler)


func get_current_spawn_range():
	var spawn_range = river_spawner.get_river_x_range()
	return spawn_range
