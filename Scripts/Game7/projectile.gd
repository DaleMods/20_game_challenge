extends Node2D

signal player_hit
signal projectile_end(end_position)

@onready var camera: Camera2D = $Camera2D

var radius := 30.0
var explosion_force := 350.0
var velocity := Vector2.ZERO
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var drag: float = ProjectSettings.get_setting("physics/2d/default_linear_damp")

var collider = null
var affected = []
var shooter_num = 0
var wind_force = 0
var hold_position = false


func _ready() -> void:
	randomize()
	var nb_points = 32
	var points = PackedVector2Array()
	for i in range(nb_points+1):
		var point = deg_to_rad(i * 360.0 / nb_points - 90)
		points.push_back(Vector2.ZERO + Vector2(cos(point), sin(point)) * radius)
	$Area2D/DestructionPolygon.polygon = points


func _physics_process(delta: float) -> void:
	if global_position.x < 0 or global_position.x > 800:
		destroy_projectile()
	elif hold_position:
		velocity = Vector2.ZERO
	elif collider == null:
		velocity.y += gravity * delta
		velocity += Vector2(wind_force, 0) * delta
		velocity = velocity * clampf(1.0 - drag * delta, 0, 1)
		position += velocity * delta
		rotation = velocity.angle()


func explode() -> void:
	for x in affected:
		x.apply_central_impulse((x.global_position - global_position).normalized() * explosion_force)
	
	$Polygon2D.visible = false
	
	if collider.is_in_group("Destructible"):
		collider.get_parent().clip($Area2D/DestructionPolygon)
	
	await get_tree().create_timer(3.5).timeout
	destroy_projectile()


func _on_collision_detection_body_entered(body: Node2D) -> void:
	if body.is_in_group("Destructible"):
		collider = body
		if body.get_parent() is Game7Rock or body.get_parent() is Game7Tree:
			$Polygon2D.visible = false
			if get_node("/root/Game7").sounds_on:
				$Debris.play()
			body.get_parent().explode()
			await get_tree().create_timer(2.5).timeout
			destroy_projectile()
		if body.get_parent() is Game7Terrain:
			$Polygon2D.visible = false
			rotation = 0
			$Explosion.emitting = true
			if get_node("/root/Game7").sounds_on:
				$Explode.play()
			explode()
	if body is Game7Player:
		if body.player_num != shooter_num:
			$Polygon2D.visible = false
			if get_node("/root/Game7").sounds_on:
				$Explode.play()
			emit_signal("player_hit")
			hold_position = true
			await get_tree().create_timer(3.5).timeout
			destroy_projectile()


func _on_timer_timeout() -> void:
	destroy_projectile()


func destroy_projectile():
	emit_signal("projectile_end", global_position)
	call_deferred("queue_free")
	get_node("/root/Game7/").players.next_player()
