class_name Pellet
extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body is Game5Player:
		var player = body
		player.eat_pellet()
		queue_free()
