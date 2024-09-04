extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func configure_windsock(wind_direction, wind_speed):
	animated_sprite_2d.flip_h = false
	if wind_direction == 1:
		animated_sprite_2d.flip_h = true
	if wind_speed == 0:
		animated_sprite_2d.play("NoWind")
	if wind_speed == 1:
		animated_sprite_2d.play("LowWind")
	if wind_speed == 2:
		animated_sprite_2d.play("HighWind")
