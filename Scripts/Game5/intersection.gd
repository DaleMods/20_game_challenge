class_name intersection
extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("at_intersection"):
		var character = body
		character.at_intersection(global_position)


func _on_body_exited(body: Node2D) -> void:
	if body.has_method("not_at_intersection"):
		var character = body
		character.not_at_intersection()
