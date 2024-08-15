extends Area2D

var movement_vector := Vector2(0, -1)
var speed := 500.0

func _physics_process(delta: float) -> void:
	global_position += movement_vector.rotated(rotation) * speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area is Asteroid:
		var asteroid = area
		asteroid.explode()
		queue_free()
	if area is Alien:
		var alien = area
		alien.explode()
		queue_free()
