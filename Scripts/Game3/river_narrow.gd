extends Node2D

const SPEED = 1.0

var spawn_notified = false

func _physics_process(delta: float) -> void:
	position.y += SPEED + delta
	if position.y >= 1199 and spawn_notified == false:
		spawn_notified = true
		get_node("/root/Game3/RiverSpawner").notify_spawn_new_segment()
	if position.y >= 1800:
		queue_free()
