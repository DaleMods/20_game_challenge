extends CharacterBody2D

@export var ball: CharacterBody2D
@export var game: Control

const SPEED = 300.0



func _physics_process(_delta: float) -> void:
	if position.x != 735:
		position.x = 735

	if game.get_game_state() == 0:
		if ball.get_y_pos() < position.y:
			velocity.y = -1 * SPEED
		if ball.get_y_pos() > position.y:
			velocity.y = 1 * SPEED
	else:
		var direction := Input.get_axis("UpArrow", "DownArrow")
		if direction:
			velocity.y = direction * SPEED
		else:
			velocity.y = move_toward(velocity.y, 0, SPEED)
		
	move_and_slide()
