extends CharacterBody2D

@export var Player1: CharacterBody2D
@export var Player2: CharacterBody2D
@export var game: Control

const SPEED = 15.0
const SPEED_MULTIPLIER = 1.05
const WIDTH = 800
const HEIGHT = 600

var start_location = Vector2(WIDTH / 2,HEIGHT / 2)


func _physics_process(delta: float) -> void:
#	if velocity.x == 0 && velocity.y == 0:
#		start_ball()
	
	var collision = move_and_collide(velocity * SPEED * delta)

	if collision:
		velocity = velocity.bounce(collision.get_normal()) * SPEED_MULTIPLIER
		if collision.get_collider_id() == Player1.get_instance_id() || collision.get_collider_id() == Player2.get_instance_id():
			get_node("BatHit").play()
		else:
			get_node("WallHit").play()
	
	if position.x < 0:
		reset()
	
	if position.x > WIDTH:
		reset()

func start_ball():
	randomize()
	velocity.x = [-1,1][randi() % 2] * SPEED
	velocity.y = [-.8,.8][randi() % 2] * SPEED


func get_y_pos():
	return position.y


func reset():
	position = start_location
	velocity = Vector2(0,0)
