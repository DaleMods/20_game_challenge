extends CharacterBody2D

@onready var health_bar: ProgressBar = $Health

const SPEED = 200.0
const ROTATION_SPEED = 8
const SCORE = 25

var health = 0
var dead = false
var target = Vector2(0,0)


func _ready() -> void:
	health = 100
	health_bar.value = health
	get_tree().create_timer(0.5).timeout.connect(shoot_bullet)


func _physics_process(delta: float) -> void:
	if health <= 0 and dead == false:
		explode()
	
	target = get_node("/root/Game3/Player").position
	var currentRotation = rotation
	var targetRotation = deg_to_rad(0)
	if target.x > (position.x + 50):
		targetRotation = deg_to_rad(-15)
		rotation = lerp_angle(currentRotation, targetRotation, ROTATION_SPEED * delta)
	elif target.x < (position.x - 50):
		targetRotation = deg_to_rad(15)
		rotation = lerp_angle(currentRotation, targetRotation, ROTATION_SPEED * delta)
	else:
		rotation = lerp_angle(currentRotation, targetRotation, ROTATION_SPEED * delta)
	
	if position.y < 400 and get_node("/root/Game3/Player").is_dead() == false:
		position = position.move_toward(target, delta * SPEED)
	else:
		rotation = lerp_angle(currentRotation, deg_to_rad(0), ROTATION_SPEED * delta)
		position.y += SPEED * delta
	
	move_and_slide()
	
	if position.y > 1000:
		queue_free()


func shot(damage):
	if dead == false:
		health -= damage
		if health < 0:
			health = 0
		health_bar.value = health
		get_node("Flying").modulate = Color.RED
		get_tree().create_timer(0.1).timeout.connect(reset_modulate)


func reset_modulate():
	get_node("Flying").modulate = Color.WHITE


func explode():
	dead = true
	get_node("CollisionShape2D").disabled = true
	get_node("Fire").emitting = true
	get_node("Smoke").emitting = true
	get_node("/root/Game3").increase_score(SCORE)
	get_tree().create_timer(1).timeout.connect(end_life_stage1)


func end_life_stage1():
	get_node("Fire").emitting = false
	get_node("Smoke").emitting = false
	get_node("Health").hide()
	get_node("Flying").hide()
	get_tree().create_timer(1).timeout.connect(end_life_stage2)



func end_life_stage2():
	queue_free()


func shoot_bullet():
	if dead == false:
		if position.y < 400 and get_node("/root/Game3/Player").is_dead() == false:
			var bullet_scene = preload("res://Scenes/Game3/enemy_bullet.tscn")
			var new_bullet = bullet_scene.instantiate()
			new_bullet.position = position
			get_node("/root/Game3/World").add_child(new_bullet)
			new_bullet.velocity = get_node("/root/Game3/Player").position - new_bullet.position
		get_tree().create_timer(0.5).timeout.connect(shoot_bullet)
