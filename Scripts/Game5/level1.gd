class_name Pacman_level_1
extends Node2D

@onready var tile_map: TileMap = $TileMap

var num_pellets := 0
var pellets_counted = false


func _process(_delta: float) -> void:
	if tile_map.get_child_count() > 0:
		if pellets_counted == false:
			pellets_counted = true
			for tile in tile_map.get_children():
				if tile is Pellet or tile is Pellet_intersection:
					num_pellets += 1


func get_player_spawn():
	return Vector2(400,440)


func get_blinky_spawn():
	return Vector2(400,280)


func get_blinky_scatter():
	return Vector2(600,0)


func get_pinky_spawn():
	return Vector2(400,300)


func get_pinky_scatter():
	return Vector2(200,0)


func get_inky_spawn():
	return Vector2(380,300)


func get_inky_scatter():
	return Vector2(500,780)


func get_clyde_spawn():
	return Vector2(420,300)


func get_clyde_scatter():
	return Vector2(300,780)


func get_num_pellets():
	if tile_map.get_child_count() > 0:
		if pellets_counted == false:
			pellets_counted = true
			for tile in tile_map.get_children():
				if tile is Pellet or tile is Pellet_intersection:
					num_pellets += 1
	return num_pellets


func _on_top_left_portal_body_entered(body: Node2D) -> void:
	if body is Game5Player or body.has_method("is_ghost"):
		var player = body
		player.position = Vector2(580,200)


func _on_top_right_portal_body_entered(body: Node2D) -> void:
	if body is Game5Player or body.has_method("is_ghost"):
		var player = body
		player.position = Vector2(220,200)


func _on_bottom_left_portal_body_entered(body: Node2D) -> void:
	if body is Game5Player or body.has_method("is_ghost"):
		var player = body
		player.position = Vector2(580,340)


func _on_bottom_right_portal_body_entered(body: Node2D) -> void:
	if body is Game5Player or body.has_method("is_ghost"):
		var player = body
		player.position = Vector2(220,340)
