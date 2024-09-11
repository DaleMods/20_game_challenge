extends CharacterBody3D

signal on_shot

var bullet_scene = preload("res://Scenes/Game8/rebel_bullet.tscn")
var explosion_scene = preload("res://Scenes/Game8/explosion.tscn")
var fire_cooldown: float = 0.0
var speed = 400
var rotation_speed = 25
var shield = 100

# CR-90 State:
# 0 - Coming onto screen
# 1 - Left broadside
# 2 - Forward
# 3 - Right broadside
# 4 - Forward
var cr90_state = 0:
	set(value):
		cr90_state = value


func _ready() -> void:
	shield = 100
	$"../../".set_boss_shield(shield)


func _physics_process(delta: float) -> void:
	if fire_cooldown > 0:
		fire_cooldown -= delta
	
	if cr90_state == 0:
		if global_position.x < 0:
			velocity.x = delta * speed
		else:
			velocity.x = 0
			cr90_state = 1
			get_tree().create_timer(5.0).timeout.connect(on_cr90_state_change)
	
	check_state(delta)
	move_and_slide()
	
	if cr90_state > 0:
		if fire_cooldown <= 0 and global_position.z < 40:
			fire_bullets()
			fire_cooldown = 50 * delta


func fire_bullets():
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


func been_shot():
	if cr90_state > 0:
		shield -= 5
		$"../../".set_boss_shield(shield)
		if shield <= 0:
			explode()


func explode():
	emit_signal("on_shot")
	var explosion = explosion_scene.instantiate()
	$"../../Bullets".add_child(explosion)
	explosion.global_position = global_position
	explosion.scale = Vector3(20, 20, 20)
	queue_free()


func on_cr90_state_change():
	cr90_state += 1
	if cr90_state > 4:
		cr90_state = 1
	
	get_tree().create_timer(5.0).timeout.connect(on_cr90_state_change)


func check_state(delta):
	if cr90_state == 1:
		var rot_degs = rotation_degrees
		if rot_degs.y < 0:
			rot_degs.y *= -1
		if rot_degs.y > 90:
			rotation_degrees = Vector3(rot_degs.x, (rot_degs.y - (delta * rotation_speed)), rot_degs.z)
			if rotation_degrees.y < 90:
				rotation_degrees.y = 90
	
	if cr90_state == 2:
		var rot_degs = rotation_degrees
		if rot_degs.y < 0:
			rot_degs.y *= -1
		if rot_degs.y < 180:
			rotation_degrees = Vector3(rot_degs.x, (rot_degs.y + (delta * rotation_speed)), rot_degs.z)
			if rotation_degrees.y < -180 or rotation_degrees.y > 180:
				rotation_degrees.y = 180
	
	if cr90_state == 3:
		var rot_degs = rotation_degrees
		if rot_degs.y < -90:
			rotation_degrees = Vector3(rot_degs.x, (rot_degs.y + (delta * rotation_speed)), rot_degs.z)
			if rotation_degrees.y > -90:
				rotation_degrees.y = -90
	
	if cr90_state == 4:
		var rot_degs = rotation_degrees
		if rot_degs.y > -180:
			rotation_degrees = Vector3(rot_degs.x, (rot_degs.y - (delta * rotation_speed)), rot_degs.z)
			if rotation_degrees.y < -180 or rotation_degrees.y > 0:
				rotation_degrees.y = -180
