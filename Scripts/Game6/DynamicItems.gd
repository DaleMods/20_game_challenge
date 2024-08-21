class_name Game6DynamicItems
extends Node

@onready var player: Game6PlayerManager = $"/root/Game6/Player"


func _ready() -> void:
	player.player_killed.connect(hold_enemy_positions)
	player.player_death_completed.connect(release_enemy_positions)


func where_is_player():
	return player.where_is_player()


func hold_enemy_positions():
	for child in get_children():
		if child.has_method("set_hold_position"):
			child.set_hold_position(true)


func release_enemy_positions():
	for child in get_children():
		if child.has_method("set_hold_position"):
			child.set_hold_position(false)


func change_crocs():
	for child in get_children():
		if child is Game6Croc:
			child.change_mouth()
