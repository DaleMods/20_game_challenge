extends Node

@onready var game: Node2D = $".."
@onready var power_pellet_music: AudioStreamPlayer2D = $"../PowerPelletMusic"
@onready var ghost_eaten_audio: AudioStreamPlayer2D = $"../GhostEaten"

var blinky_scene = preload("res://Scenes/Game5/blinky.tscn")
var pinky_scene = preload("res://Scenes/Game5/pinky.tscn")
var inky_scene = preload("res://Scenes/Game5/inky.tscn")
var clyde_scene = preload("res://Scenes/Game5/clyde.tscn")

var frightened_timer = 0.0
var eaten_count = 0
var frightened = false
var blink_frightened = false


func _process(delta: float) -> void:
	if frightened == true:
		if frightened_timer > 0:
			frightened_timer -= delta
			if power_pellet_music.playing == false:
				power_pellet_music.play()
		if frightened_timer <= 2 and blink_frightened == false:
			blink_frightened = true
			if get_child_count() > 0:
				for child in get_children():
					child.is_blue = false
					child.is_blink_blue = true
		if frightened_timer < 0:
			frightened_timer = 0
			frightened = false
			if get_child_count() > 0:
				for child in get_children():
					child.is_blue = false
					child.is_blink_blue = false


func spawn_ghosts(level, active_level):
	if get_child_count() > 0:
		for child in get_children():
			child.queue_free()
	while level.get_child_count() == 0:
		await get_tree().create_timer(0.1).timeout
	if active_level.has_method("get_blinky_spawn"):
		var pos = active_level.get_blinky_spawn()
		ghost_properties(blinky_scene, pos, "Blinky")
	if active_level.has_method("get_pinky_spawn"):
		var pos = active_level.get_pinky_spawn()
		ghost_properties(pinky_scene, pos, "Pinky")
	if active_level.has_method("get_inky_spawn"):
		var pos = active_level.get_inky_spawn()
		ghost_properties(inky_scene, pos, "Inky")
	if active_level.has_method("get_clyde_spawn"):
		var pos = active_level.get_clyde_spawn()
		ghost_properties(clyde_scene, pos, "Clyde")


func ghost_properties(scene, pos, ghost_name):
	var ghost = scene.instantiate()
	ghost.global_position = pos
	ghost.name = ghost_name
	ghost.is_in_ghost_house = true
	ghost.got_player.connect(hold_ghosts)
	ghost.got_eaten.connect(ghost_eaten)
	call_deferred("add_child", ghost)
	ghost.start_game()


func hold_ghosts():
	if get_child_count() > 0:
		for child in get_children():
			child.hold_position = true


func release_ghosts():
	if get_child_count() > 0:
		for child in get_children():
			child.hold_position = false


func switching_chase_scatter(state):
	if game.game_state == 0:
		return
	if get_child_count() > 0:
		for child in get_children():
			child.switch_chase_scatter_state(state)


func power_pellet_eaten():
	frightened_timer = 6.0 - (game.current_level * 0.3)
	if frightened_timer < 0:
		frightened_timer = 0
	eaten_count = 0
	frightened = true
	if get_child_count() > 0:
		for child in get_children():
			child.is_blue = true


func ghost_eaten(pos):
	ghost_eaten_audio.play()
	var scores = [0,200,400,800,1600]
	eaten_count += 1
	game.add_score(scores[eaten_count], pos)


func get_blinky_position():
	if get_child_count() > 0:
		for child in get_children():
			if child is ghost_blinky:
				return child.global_position
	return Vector2.ZERO


func remove_ghosts():
	if get_child_count() > 0:
		for child in get_children():
			child.queue_free()
