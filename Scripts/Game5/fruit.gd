class_name fruit
extends Area2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var chomp: AudioStreamPlayer2D = $chomp

var level = 0
var score_array = [100,300,500,700,1000,2000,3000,5000]
var game: Node2D


func _ready() -> void:
	game = get_node("/root/Game5")


func set_fruit(value):
	level = value % 8
	sprite_2d.set_region_enabled(true)
	sprite_2d.set_region_rect(Rect2((value * 28), 0, 28, 28))
	await get_tree().create_timer(10).timeout
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is Game5Player:
		chomp.play()
		var score = score_array[level]
		game.add_score(score, global_position)
		await get_tree().create_timer(0.44).timeout
		queue_free()
