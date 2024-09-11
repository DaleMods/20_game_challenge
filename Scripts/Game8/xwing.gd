extends CharacterBody3D

signal on_shot

var speed = randf_range(40, 60)
var bullet_scene = preload("res://Scenes/Game8/rebel_bullet.tscn")
var explosion_scene = preload("res://Scenes/Game8/explosion.tscn")
var fire_cooldown: float = 0.0


func _physics_process(delta: float) -> void:
	if fire_cooldown > 0:
		fire_cooldown -= delta
	
	velocity = Vector3(0, 0, -speed)
	
	move_and_slide()
	
	if transform.origin.z < -100:
		queue_free()
	
	if fire_cooldown <= 0 and global_position.z < 40:
		var bullet1 = bullet_scene.instantiate()
		$"../../Bullets".add_child(bullet1)
		bullet1.global_position = $Gun0.global_position
		bullet1.velocity = Vector3(0, 0, -100)
		var bullet2 = bullet_scene.instantiate()
		$"../../Bullets".add_child(bullet2)
		bullet2.global_position = $Gun1.global_position
		bullet2.velocity = Vector3(0, 0, -100)
		var bullet3 = bullet_scene.instantiate()
		$"../../Bullets".add_child(bullet3)
		bullet3.global_position = $Gun2.global_position
		bullet3.velocity = Vector3(0, 0, -100)
		var bullet4 = bullet_scene.instantiate()
		$"../../Bullets".add_child(bullet4)
		bullet4.global_position = $Gun3.global_position
		bullet4.velocity = Vector3(0, 0, -100)
		$Laser.play()
		fire_cooldown = 200 * delta


func explode():
	emit_signal("on_shot")
	var explosion = explosion_scene.instantiate()
	$"../../Bullets".add_child(explosion)
	explosion.global_position = global_position
	queue_free()
