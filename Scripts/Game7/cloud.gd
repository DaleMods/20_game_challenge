extends Node2D

var speed = 0.0
var spawn: Vector2
var wind_direction: int
var wind_speed: int


func _process(delta: float) -> void:
	if wind_direction == 0:
		global_position.x += delta * speed
	else:
		global_position.x -= delta * speed
	if global_position.x < -1500 or global_position.x > 1500:
		queue_free()


func configure_cloud(wind_dir, wind_sp):
	wind_direction = wind_dir
	wind_speed = wind_sp
	
	var cloud_x = -1500
	if wind_speed == 0:
		speed = randf_range(0, 2)
	elif wind_speed == 1:
		speed = randf_range(25, 50)
	elif wind_speed == 2:
		speed = randf_range(50, 100)
	
	if wind_direction == 1:
		cloud_x = 1500
	
	var cloud_y = randi_range(-50, 300)
	global_position = Vector2(cloud_x, cloud_y)
