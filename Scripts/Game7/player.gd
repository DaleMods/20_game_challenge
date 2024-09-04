class_name Game7Player
extends CharacterBody2D

@onready var muzzle: Marker2D = $Turret/Muzzle
@onready var camera: Camera2D = $Camera2D
@onready var player_deets: Control = $PlayerDeets
@onready var player_label: Label = $PlayerDeets/Label
@onready var progress_bar: ProgressBar = $PlayerDeets/ProgressBar
@onready var tank_sprite: Sprite2D = $Tank
@onready var turret_sprite: Sprite2D = $Turret
@onready var ai: Node = $AI

var speed = 200.0
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var drag: float = ProjectSettings.get_setting("physics/2d/default_linear_damp")
var wind_force = 150
var explosion_force = 1000.0
var mouse_button_pressed = false
var is_human = true
var is_active = false
var fire_projectile = false
var fired_this_round = false
var player_num = 0
var zoom_speed = Vector2(0.05, 0.05)
var pan_speed = Vector2(10, 0)


func configure_player(num, flip, human):
	is_human = human
	player_num = num
	player_label.text = "Player " + str(player_num)
	
	# Flip graphics if player 2
	if flip:
		tank_sprite.flip_h = true
		turret_sprite.position.x *= -1
	
	if player_num == 2 and is_human == false:
		turret_sprite.rotate(deg_to_rad(ai.calc_angle))


func afix_player_deets():
	# Fix player details box on screen
	if player_num == 1:
		player_deets.global_position = Vector2(20, 20)
	if player_num == 2:
		player_deets.global_position = Vector2(580, 20)


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	
	afix_player_deets()
	move_and_slide()
	
	# Skip if player already fired or not their turn
	if fired_this_round:
		return
	
	fire_projectile = false
	
	# Process human input
	if is_active:
		if is_human:
			process_human_input(delta)
		else:
			process_ai(delta)
	
	# Process barrel movement
	if player_num == 1 and is_human:
		if get_global_mouse_position().x > turret_sprite.global_position.x and get_global_mouse_position().y < turret_sprite.global_position.y:
			turret_sprite.look_at(get_global_mouse_position())
	if player_num == 2 and is_human:
		if get_global_mouse_position().x < turret_sprite.global_position.x and get_global_mouse_position().y < turret_sprite.global_position.y:
			turret_sprite.look_at(get_global_mouse_position())
	
	if fire_projectile == true:
		fire_new_projectile()


func process_ai(delta):
	if ai.done_calculating:
		if progress_bar.value < ai.calc_speed:
			print("1")
			progress_bar.value += delta
		if progress_bar.value >= ai.calc_speed:
			print("2")
			fire_projectile = true
		turret_sprite.rotate(deg_to_rad(ai.calc_angle - ai.last_angle))
		print(str(progress_bar.value) + " - " + str(ai.calc_speed))
	else:
		ai.do_ai_turn()


func process_human_input(delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) and mouse_button_pressed == false:
		progress_bar.value += delta
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and mouse_button_pressed == false:
		fire_projectile = true
	
	if Input.is_action_pressed("LeftArrow"):
		velocity.x -= speed * delta
	
	if Input.is_action_pressed("RightArrow"):
		velocity.x += speed * delta


func fire_new_projectile():
	mouse_button_pressed = true
	fired_this_round = true
	if get_node("/root/Game7").sounds_on:
		$Fire.play()
	var projectile_scene = preload("res://Scenes/Game7/projectile.tscn")
	var projectile = projectile_scene.instantiate()
	projectile.position = turret_sprite.position
	projectile.velocity = explosion_force * progress_bar.value * get_forward_direction()
	projectile.shooter_num = player_num
	projectile.player_hit.connect(get_parent().player_hit)
	projectile.projectile_end.connect(projectile_end_update_ai_values)
	var wind_dir = get_parent().get_wind_direction()
	var wind_sp = get_parent().get_wind_speed()
	if wind_dir == 0:
		projectile.wind_force = wind_sp * wind_force
	else:
		projectile.wind_force = wind_sp * -wind_force
	add_child(projectile)
	await get_tree().create_timer(0.2).timeout
	progress_bar.value = 0
	mouse_button_pressed = false


func get_forward_direction():
	return global_position.direction_to(muzzle.global_position)


func explode():
	$Turret.visible = false
	$Tank.visible = false
	$Explosion.emitting = true
	await get_tree().create_timer(3.5).timeout
	queue_free()


func projectile_end_update_ai_values(end_position):
	ai.update_ai_with_projectile_values(end_position)
