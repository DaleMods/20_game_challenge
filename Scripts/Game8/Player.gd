class_name Game8Player
extends CharacterBody3D

var speed = 40
var acceleration = 1.25
var inputVector = Vector3()
var bullet_scene = preload("res://Scenes/Game8/player_bullet.tscn")
var explosion_scene = preload("res://Scenes/Game8/explosion.tscn")
var fire_cooldown: float = 0.0
var shield = 100


func _ready() -> void:
	shield = 100
	get_parent().set_player_shield(shield)


func _physics_process(delta: float) -> void:
	if fire_cooldown > 0:
		fire_cooldown -= delta
	
	inputVector.x = Input.get_action_strength("A") - Input.get_action_strength("D")
	inputVector.y = Input.get_action_strength("W") - Input.get_action_strength("S")
	inputVector = inputVector.normalized()
	
	velocity.x = move_toward(velocity.x, inputVector.x * speed, acceleration)
	velocity.y = move_toward(velocity.y, inputVector.y * speed, acceleration)
	
	if velocity.x > 20 or velocity.y > 20:
		if $Roll1.playing == false and $Roll2.playing == false:
			var flying = randi_range(0,1)
			if flying == 0:
				$Roll1.play()
			else:
				$Roll2.play()
	
	rotation_degrees.z = velocity.x * -1.5
	rotation_degrees.x = velocity.y / 1.5
	rotation_degrees.y = -velocity.x / 1.5
	
	move_and_slide()
	
	transform.origin.x = clamp(transform.origin.x, -15, 15)
	transform.origin.y = clamp(transform.origin.y, -10, 10)
	
	if Input.is_action_pressed("Space") and fire_cooldown <= 0:
		var bullet1 = bullet_scene.instantiate()
		$"../Bullets".add_child(bullet1)
		bullet1.global_position = $Gun0.global_position
		bullet1.velocity = Vector3(0, 0, 100)
		var bullet2 = bullet_scene.instantiate()
		$"../Bullets".add_child(bullet2)
		bullet2.global_position = $Gun1.global_position
		bullet2.velocity = Vector3(0, 0, 100)
		$Laser.play()
		fire_cooldown = 16 * delta


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Rebel"):
		body.explode()
		shield -= 10
		get_parent().set_player_shield(shield)
		if shield <= 0:
			explode()


func been_shot():
	shield -= 20
	get_parent().set_player_shield(shield)
	if shield <= 0:
		explode()


func been_repaired():
	shield += 20
	if shield > 100:
		shield = 100
	get_parent().set_player_shield(shield)


func explode():
	var explosion = explosion_scene.instantiate()
	$"../Bullets".add_child(explosion)
	explosion.global_position = global_position
	get_parent().end_game()
	queue_free()
