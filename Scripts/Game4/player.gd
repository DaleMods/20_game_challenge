class_name Player
extends CharacterBody2D

signal rocket_shot(rocket)
signal died
signal on_teleport(value)

@onready var muzzle: Node2D = $Muzzle
@onready var cshape: CollisionShape2D = $CollisionShape2D

var acceleration := 20.0
var max_speed := 150.0
var rotation_speed := 150.0
var rate_of_fire = 0.3
var rocket_scene = preload("res://Scenes/Game4/rocket.tscn")
var shoot_cd = false
var alive = true
var can_teleport = true
var teleport_timer = 5


func _ready() -> void:
	alive = false


func _process(_delta: float) -> void:
	if alive == true:
		if Input.is_action_pressed("Space"):
			if !shoot_cd:
				shoot_cd = true
				shoot_rocket()
				await get_tree().create_timer(rate_of_fire).timeout
				shoot_cd = false


func _physics_process(delta: float) -> void:
	if alive == true:
		var input_vector := Vector2(0, 0)
		
		if Input.is_action_pressed("W"):
			input_vector.y = -1
		
		if Input.is_action_just_pressed("Z"):
			if can_teleport == true:
				teleport()
		
		velocity += input_vector.rotated(rotation) * acceleration
		velocity = velocity.limit_length(max_speed)
		
		if Input.is_action_pressed("D"):
			rotate(deg_to_rad(rotation_speed * delta))
		if Input.is_action_pressed("A"):
			rotate(deg_to_rad(-rotation_speed * delta))
		
		if input_vector.y == 0:
			velocity = velocity.move_toward(Vector2.ZERO, 1)
			get_node("AnimatedSprite2D").hide()
		else:
			get_node("AnimatedSprite2D").show()
		
		move_and_slide()
		
		var screen_size = get_viewport_rect().size
		
		if global_position.y < 0:
			global_position.y = screen_size.y
		elif global_position.y > screen_size.y:
			global_position.y = 0
		if global_position.x < 0:
			global_position.x = screen_size.x
		elif global_position.x > screen_size.x:
			global_position.x = 0


func shoot_rocket():
	var rocket = rocket_scene.instantiate()
	rocket.global_position = muzzle.global_position
	rocket.rotation = rotation
	$LaserSound.play()
	emit_signal("rocket_shot", rocket)


func die():
	if alive == true:
		alive = false
		cshape.set_deferred("disabled", true)
		$ExplodeSound.play()
		emit_signal("died")
		hide()


func new_game():
	can_teleport = true
	emit_signal("on_teleport", "ON")


func respawn(pos):
	if alive == false:
		alive = true
		global_position = pos
		velocity = Vector2.ZERO
		cshape.set_deferred("disabled", false)
		show()


func teleport():
	can_teleport = false
	emit_signal("on_teleport", "OFF")
	var screen_size = get_viewport_rect().size
	var x = randi_range(50, (screen_size.x - 50))
	var y = randi_range(50, (screen_size.y - 50))
	global_position = Vector2(x, y)
	await get_tree().create_timer(teleport_timer).timeout
	can_teleport = true
	emit_signal("on_teleport", "ON")
