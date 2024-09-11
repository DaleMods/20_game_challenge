extends CharacterBody3D

signal on_shot

var speed = randf_range(5, 15)
var explosion_scene = preload("res://Scenes/Game8/explosion.tscn")


func _physics_process(_delta: float) -> void:
	position.y = -40
	velocity = Vector3(0, 0, -speed)
	
	move_and_slide()
	
	if transform.origin.z < -100:
		queue_free()


func explode():
	var explosion = explosion_scene.instantiate()
	$"../../Bullets".add_child(explosion)
	explosion.global_position = global_position
	explosion.scale = Vector3(10, 10, 10)
	queue_free()
