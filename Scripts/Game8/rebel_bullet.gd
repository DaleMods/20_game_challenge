extends CharacterBody3D

func _physics_process(_delta: float) -> void:
	move_and_slide()
	
	if global_position.z < -100:
		queue_free()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Game8Player:
		body.been_shot()
		queue_free()
