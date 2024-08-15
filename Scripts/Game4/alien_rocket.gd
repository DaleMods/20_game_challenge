extends Area2D

var movement_vector := Vector2(0, -1)
var speed := 500.0

func _physics_process(delta: float) -> void:
	global_position += movement_vector.rotated(rotation) * speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		var player = body
		if player.alive == true:
			player.die()
