extends CharacterBody2D


const SPEED = 300.0

var target_x = 0;


func _physics_process(_delta: float) -> void:
	if position.y != 550:
		position.y = 550
	
	if target_x > 0:
		velocity.x = 0
		if (position.x - target_x) < -30:
			velocity.x = 1 * SPEED
		if (position.x - target_x) > 30:
			velocity.x = -1 * SPEED
	else:
		var direction := Input.get_axis("LeftArrow", "RightArrow")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = 0

	move_and_slide()


func demo_position_set(ball_x):
	target_x = ball_x

