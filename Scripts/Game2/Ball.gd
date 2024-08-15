extends CharacterBody2D

@export var player: CharacterBody2D
@export var leftwall: StaticBody2D
@export var rightwall: StaticBody2D
@export var topwall: StaticBody2D


const SPEED = 15.0
const SPEED_MULTIPLIER = 1.001
const PLAYER_TO_BALL_DISTANCE = 26

var stuckToPaddle = true
var demo_mode = false


func _ready() -> void:
	reset_ball()


func _physics_process(delta: float) -> void:
	if stuckToPaddle:
		position = Vector2(player.position.x, (player.position.y - PLAYER_TO_BALL_DISTANCE))
		if Input.is_action_just_pressed("Space") or demo_mode == true:
			start_ball()
	else:
		if position.y > (player.position.y + 100):
			velocity = Vector2.ZERO
			position.y = player.position.y + 75

		var collision = move_and_collide(velocity * SPEED * delta)
		if collision:
			if collision.get_collider_id() == player.get_instance_id():
				bounce_bat()
			elif collision.get_collider_id() == leftwall.get_instance_id() or collision.get_collider_id() == rightwall.get_instance_id():
				bounce_left_right_walls()
			elif collision.get_collider_id() == topwall.get_instance_id():
				bounce_top_wall()
			else:
				bounce_brick(collision)


func bounce_brick(collision):
	velocity = velocity.bounce(collision.get_normal()) * SPEED_MULTIPLIER
	get_node("BatHit").play()


func bounce_left_right_walls():
	velocity.x = -velocity.x * SPEED_MULTIPLIER
	velocity.y = velocity.y * SPEED_MULTIPLIER
	get_node("WallHit").play()


func bounce_top_wall():
	velocity.x = velocity.x * SPEED_MULTIPLIER
	velocity.y = -velocity.y * SPEED_MULTIPLIER
	get_node("WallHit").play()


func bounce_bat():
	velocity.x = (1 - ((player.position.x - position.x) * SPEED / 50))
	velocity.y = -velocity.y
	get_node("BatHit").play()


func start_ball():
	stuckToPaddle = false
	randomize()
	velocity.x = (1 - ((player.position.x - position.x) * SPEED / 50))
	velocity.y = -1 * SPEED



func reset_ball():
	stuckToPaddle = true
	velocity = Vector2.ZERO


func set_demo_mode(state: bool):
	demo_mode = state
