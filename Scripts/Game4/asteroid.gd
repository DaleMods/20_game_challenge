class_name Asteroid
extends Area2D

signal exploded(pos, size, points)

@onready var sprites_1: AnimatedSprite2D = $Sprites1
@onready var sprites_2: AnimatedSprite2D = $Sprites2
@onready var sprites_3: AnimatedSprite2D = $Sprites3

enum AsteroidSize { LARGE, MEDIUM, SMALL }

var movement_vector := Vector2(0, -1)
var speed := 50
var size := AsteroidSize.LARGE
var points: int:
	get:
		match size:
			AsteroidSize.LARGE:
				return 50
			AsteroidSize.MEDIUM:
				return 100
			AsteroidSize.SMALL:
				return 200
			_:
				return 0


func _ready() -> void:
	var type = randi_range(0, 2)
	
	match type:
		0:
			sprites_1.show()
			sprites_2.hide()
			sprites_3.hide()
		1:
			sprites_1.hide()
			sprites_2.show()
			sprites_3.hide()
		2:
			sprites_1.hide()
			sprites_2.hide()
			sprites_3.show()
			
	rotation = randf_range(0, 2 * PI)
	
	match size:
		AsteroidSize.LARGE:
			speed = randi_range(25, 50)
			scale = Vector2(1.0, 1.0)
		AsteroidSize.MEDIUM:
			speed = randi_range(50, 100)
			scale = Vector2(0.6, 0.6)
		AsteroidSize.SMALL:
			speed = randi_range(100, 150)
			scale = Vector2(0.3, 0.3)


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


func explode():
	emit_signal("exploded", global_position, size, points)
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		var player = body
		if player.alive == true:
			player.die()
