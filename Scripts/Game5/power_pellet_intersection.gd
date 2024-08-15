class_name PowerPellet_intersection
extends Area2D

@onready var sprite_2d: Sprite2D = $Sprite2D

var pellet_active = true


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("at_intersection"):
		var character = body
		character.at_intersection(global_position)
		if pellet_active and character.has_method("eat_power_pellet"):
			character.eat_power_pellet()
			sprite_2d.hide()
			pellet_active = false



func _on_body_exited(body: Node2D) -> void:
	if body.has_method("not_at_intersection"):
		var character = body
		character.not_at_intersection()
