extends CharacterBody2D

@onready var health_bar: ProgressBar = $Health
@onready var fuel_bar: ProgressBar = $Fuel

const SPEED = 300.0
const ROTATION_SPEED = 10
const FUEL_USE_PER_TICK = 1
const REFUEL_AMOUNT = 25


var health = 0
var fuel = 0.0
var fuel_tank = 1000.0
var dead = false
var exploded = false
var game_playing = false

signal game_ended

func _ready() -> void:
	health = 100
	health_bar.value = health
	fuel = fuel_tank
	fuel_bar.value = (fuel * 100) / fuel_tank
	dead = true
	hide()


func set_game_playing(state):
	game_playing = state
	if game_playing:
		reset_player()


func _physics_process(delta: float) -> void:
	if exploded or game_playing == false:
		return
	if fuel > 0:
		fuel -= FUEL_USE_PER_TICK
		fuel_bar.value = (fuel * 100) / fuel_tank
	if fuel <= 0:
		fuel = 0
		explode()
	if health <= 0 and dead == false:
		explode()
	
	if Input.is_action_just_pressed("Space"):
		spawn_bullet()
	if Input.is_action_just_pressed("Z"):
		spawn_torpedo()
	var direction := Input.get_axis("LeftArrow", "RightArrow")
	var currentRotation = rotation
	var targetRotation = deg_to_rad(0)
	if direction:
		if direction < 0:
			targetRotation = deg_to_rad(-15)
			rotation = lerp_angle(currentRotation, targetRotation, ROTATION_SPEED * delta)
		if direction > 0:
			targetRotation = deg_to_rad(15)
			rotation = lerp_angle(currentRotation, targetRotation, ROTATION_SPEED * delta)
		velocity.x = direction * SPEED
	else:
		rotation = lerp_angle(currentRotation, targetRotation, ROTATION_SPEED * delta)
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if dead:
		position.y -= SPEED * delta
	else:
		if position.y != 500:
			position.y = 500
	
	move_and_slide()


func damage_player(damage):
	health -= damage
	health_bar.value = health
	get_node("Flying").modulate = Color.RED
	get_tree().create_timer(0.1).timeout.connect(reset_modulate)


func reset_modulate():
	get_node("Flying").modulate = Color.WHITE


func explode():
	dead = true
	get_node("Label").hide()
	get_node("Label2").hide()
	get_node("CollisionShape2D").disabled = true
	get_node("Fire").emitting = true
	get_node("Smoke").emitting = true
	get_tree().create_timer(1).timeout.connect(end_life_stage1)


func end_life_stage1():
	get_node("Fire").emitting = false
	get_node("Smoke").emitting = false
	get_node("Health").hide()
	get_node("Fuel").hide()
	get_node("Flying").hide()
	get_tree().create_timer(1).timeout.connect(end_life_stage2)



func end_life_stage2():
	exploded = true
	game_ended.emit()


func reset_player():
	dead = false
	exploded = false
	health = 100
	health_bar.value = health
	fuel = fuel_tank
	fuel_bar.value = (fuel * 100) / fuel_tank
	show()
	get_node("CollisionShape2D").disabled = false
	get_node("Label").show()
	get_node("Label2").show()
	get_node("Health").show()
	get_node("Fuel").show()
	get_node("Flying").show()


func spawn_bullet():
	var bullet_scene = preload("res://Scenes/Game3/bullet.tscn")
	var new_bullet = bullet_scene.instantiate()
	new_bullet.position = position
	get_tree().root.get_node("Game3").add_child(new_bullet)
	if get_node("Shoot").playing == true:
		get_node("Shoot").stop()
	get_node("Shoot").play()


func spawn_torpedo():
	var torp_scene = preload("res://Scenes/Game3/torpedo.tscn")
	var new_torp = torp_scene.instantiate()
	new_torp.position = position
	get_tree().root.get_node("Game3").add_child(new_torp)
	if get_node("Torpedo").playing == true:
		get_node("Torpedo").stop()
	get_node("Torpedo").play()


func is_dead():
	return dead


func refuel():
	fuel += REFUEL_AMOUNT
	if get_node("Refuel").playing == false:
		get_node("Refuel").play()
	if fuel > fuel_tank:
		fuel = fuel_tank
	fuel_bar.value = (fuel * 100) / fuel_tank
