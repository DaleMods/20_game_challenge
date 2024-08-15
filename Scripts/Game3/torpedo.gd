extends Sprite2D


const SPEED = 200.0
const DAMAGE = 25


func _physics_process(delta: float) -> void:
	global_position -= Vector2(0, SPEED * delta)
	if position.y < -50:
		queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("torpedoed"):
		body.torpedoed(DAMAGE)
		queue_free()
