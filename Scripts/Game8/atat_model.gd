extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	do_animation()


func do_animation():
	animation_player.play("Walk and shoot")
