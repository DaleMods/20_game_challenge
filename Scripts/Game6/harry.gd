class_name Game6Harry
extends CharacterBody2D

signal harry_killed
signal death_completed
signal treasure_got

var walk_speed = 250.0
var climb_speed = 100
var jump_speed = -300.0

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

var hold_position = false
var can_climb = false
var is_climbing = false
var is_jumping = false
var is_falling = false
var is_on_temp_safe_body = false
var temp_safe_body: CharacterBody2D = null
var is_on_vine = false
var vine: Area2D = null
var playing = false


func _physics_process(delta: float) -> void:
	if hold_position:
		return
	
	if playing == false:
		return
	
	if is_on_vine:
		if vine == null:
			is_on_vine = false
		else:
			$AnimatedSprite2D.play("swing")
			global_position = vine.get_node("GrabSpot").global_position
			if Input.is_action_pressed("Space"):
				is_on_vine = false
				vine = null
			else:
				return
	
	if not is_on_floor() and is_climbing == false:
		velocity.y += gravity * delta
		if velocity.y > 0 and is_jumping == false and is_falling == false and is_climbing == false:
			is_falling = true
			$Falling.play()
	else:
		velocity.y = 0
		is_jumping = false
		is_falling = false
		if $Falling.playing == true:
			$Falling.stop()
		if $Jump.playing == true:
			$Jump.stop()
	
	if playing:
		do_input()
		do_animation()
		move_and_slide()


func do_input():
	if is_on_temp_safe_body:
		if temp_safe_body != null:
			if temp_safe_body.can_kill_harry:
				is_on_temp_safe_body = false
				temp_safe_body = null
				die()
				return
	
	if Input.is_action_pressed("Space") and (is_on_floor() or is_climbing):
		velocity.y = jump_speed
		$Jump.play()
		is_jumping = true

	var direction := Input.get_axis("A", "D")
	if direction:
		velocity.x = direction * walk_speed
	else:
		velocity.x = move_toward(velocity.x, 0, walk_speed)
	
	if can_climb:
		var vert_direction := Input.get_axis("W", "S")
		if vert_direction:
			velocity.y = vert_direction * climb_speed
			is_climbing = true


func do_animation():
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
	
	if velocity.x != 0:
		$AnimatedSprite2D.play("run")
	elif velocity.y != 0 and can_climb:
		$AnimatedSprite2D.play("climb")
	else:
		$AnimatedSprite2D.play("idle")
	
	if not is_on_floor() and is_jumping:
		$AnimatedSprite2D.play("jump")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if playing == false:
		return
	if body.is_treasure:
		$Treasure.play()
		emit_signal("treasure_got")
	elif body.can_climb:
		can_climb = true
		if not is_on_floor():
			is_climbing = true
	elif body.is_temp_safe and body.can_kill_harry == false:
		is_on_temp_safe_body = true
		temp_safe_body = body
	elif body.can_kill_harry:
		die()


func _on_area_2d_body_exited(_body: Node2D) -> void:
	can_climb = false
	is_climbing = false
	is_on_temp_safe_body = false
	temp_safe_body = null


func die():
	$AnimatedSprite2D.stop()
	hold_position = true
	emit_signal("harry_killed")
	$Death.play()
	await get_tree().create_timer(1.0).timeout
	emit_signal("death_completed")


func reset_harry(reset_position):
	if playing == false:
		return
	global_position = reset_position
	hold_position = false
	can_climb = false
	is_climbing = false
	is_jumping = false
	is_falling = false
	is_on_temp_safe_body = false
	temp_safe_body = null
	$AnimatedSprite2D.flip_h = false
	velocity = Vector2.ZERO


func end_game():
	hold_position = true
	playing = false
	$AnimatedSprite2D.play("run")
