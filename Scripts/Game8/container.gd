class_name Game8Container
extends StaticBody3D

signal player_container

var speed = randf_range(20, 30)


func _physics_process(delta: float) -> void:
	global_position.z -= speed * delta
	
	if global_position.z < -10:
		queue_free()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Game8Player:
		emit_signal("player_container")
		queue_free()
