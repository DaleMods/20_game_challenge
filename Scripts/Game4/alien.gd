class_name Alien
extends Area2D

signal exploded(points)

@onready var muzzle: Node2D = $Muzzle

var movement_vector := Vector2(0, -1)
var speed := 50
var rotation_speed := 100.0
var points := 250
var rate_of_fire = 0.5
var rate_of_direction = 1.0
var rocket_scene = preload("res://Scenes/Game4/alien_rocket.tscn")
var shoot_cd = false
var direction_cd = false
var new_rotation = randf_range(0, 2 * PI)


func _ready() -> void:
	rotation = new_rotation


func _physics_process(delta: float) -> void:
	global_position += movement_vector.rotated(rotation) * speed * delta
	
	var radius = get_node("CollisionShape2D").shape.radius
	var screen_size = get_viewport_rect().size
	
	if (global_position.y + radius) < 0:
		global_position.y = (screen_size.y + radius)
	elif (global_position.y - radius) > screen_size.y:
		global_position.y = -radius
	if (global_position.x + radius) < 0:
		global_position.x = (screen_size.x + radius)
	elif (global_position.x - radius) > screen_size.x:
		global_position.x = -radius
	
	if rotation < new_rotation:
		rotate(deg_to_rad(rotation_speed * delta))
	if rotation > new_rotation:
		rotate(deg_to_rad(-rotation_speed * delta))
	
	do_shoot_rocket()
	change_direction()


func change_direction():
	if !direction_cd:
		direction_cd = true
		new_rotation = randf_range(0, 2 * PI)
		await get_tree().create_timer(rate_of_direction).timeout
		direction_cd = false


func explode():
	emit_signal("exploded", points)
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		var player = body
		if player.alive == true:
			player.die()


func do_shoot_rocket():
	if !shoot_cd:
		shoot_cd = true
		shoot_rocket()
		await get_tree().create_timer(rate_of_fire).timeout
		shoot_cd = false


func shoot_rocket():
	var rocket = rocket_scene.instantiate()
	rocket.global_position = muzzle.global_position
	rocket.rotation = rotation
	$LaserSound.play()
	get_node("/root/Game4/Rockets").add_child(rocket)
