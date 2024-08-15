extends CharacterBody2D


class_name Brick

signal brick_destroyed

var level = 1

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var ball: CharacterBody2D = $"../../Ball"

var sprites: Array[Texture2D] = [
	preload("res://Assets/Sprites/Game2/black-brick.png"),
	preload("res://Assets/Sprites/Game2/blue-brick.png"),
	preload("res://Assets/Sprites/Game2/brown-brick.png"),
	preload("res://Assets/Sprites/Game2/darkgreen-brick.png"),
	preload("res://Assets/Sprites/Game2/green-brick.png"),
	preload("res://Assets/Sprites/Game2/orange-brick.png"),
	preload("res://Assets/Sprites/Game2/purple-brick.png"),
	preload("res://Assets/Sprites/Game2/red-brick.png"),
	preload("res://Assets/Sprites/Game2/sky-brick.png"),
	preload("res://Assets/Sprites/Game2/yellow-brick.png")
]

func get_size():
	return collision_shape_2d.shape.get_rect().size


func set_level(new_level: int):
	level = new_level
	sprite_2d.texture = sprites[new_level - 1]


func decrease_level():
	if level > 1:
		set_level(level - 1)
	else:
		fade_out()


func fade_out():
	collision_shape_2d.set_deferred("disabled", true)
	var tween = get_tree().create_tween()
	tween.tween_property(sprite_2d, "modulate", Color.TRANSPARENT, .5)
	tween.tween_callback(destroy)


func destroy():
	queue_free()
	brick_destroyed.emit()


func get_width():
	return get_size().x



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == ball:
		decrease_level()
