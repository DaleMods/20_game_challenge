class_name Game6Vine
extends Area2D

var vine_active = false
var swing_speed = 50
var swing_direction = 1


func _physics_process(delta: float) -> void:
	if vine_active:
		rotation_degrees += delta * swing_speed * swing_direction
		if rotation_degrees >= 60:
			swing_direction = -1
		if rotation_degrees <= -60:
			swing_direction = 1


func _on_body_entered(body: Node2D) -> void:
	if body is Game6Harry:
		if body.is_jumping:
			body.is_on_vine = true
			body.vine = self
			$AudioStreamPlayer2D.play()
