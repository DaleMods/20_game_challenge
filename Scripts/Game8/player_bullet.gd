extends CharacterBody3D

func _physics_process(_delta: float) -> void:
	move_and_slide()
	
	if global_position.z > 50:
		queue_free()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Rebel"):
		body.explode()
		queue_free()
	if body.is_in_group("Boss"):
		body.been_shot()
		queue_free()
