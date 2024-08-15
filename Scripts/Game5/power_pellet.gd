class_name Power_Pellet
extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body is Game5Player:
		var player = body
		player.eat_power_pellet()
		queue_free()
