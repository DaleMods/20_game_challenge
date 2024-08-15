extends Node2D

@onready var rockets: Node = $Rockets
@onready var player: CharacterBody2D = $Player
@onready var asteroids: Node = $Asteroids
@onready var ui = $UI
@onready var spawn_point = $SpawnPoint
@onready var game_over_label = $UI/GameOver
@onready var space_start_label = $UI/SpaceToStart
@onready var waiting_label = $UI/Waiting
@onready var instructions_label = $UI/Instructions
@onready var spawn_area = $PlayerSpawnArea
@onready var aliens: Node = $Aliens

var asteroid_scene = preload("res://Scenes/Game4/asteroid.tscn")
var alien_scene = preload("res://Scenes/Game4/alien.tscn")
var this_scene_loaded = false
var playing_game = false
var base_number_asteroids = 3
var alien_timeout = 10.0


var score := 0:
	set(value):
		score = value
		ui.score = value

var lives = 3:
	set(value):
		lives = value
		ui.init_lives(lives)

var level = 1:
	set(value):
		level = value
		ui.level = value


var teleport = "ON":
	set(value):
		teleport = value
		ui.teleport = value


func _ready() -> void:
	score = 0
	lives = 3
	level = 1
	player.connect("rocket_shot", _on_player_shot_rocket)
	player.connect("died", _on_player_died)
	player.connect("on_teleport", _on_teleport)
	
	game_over_label.hide()
	space_start_label.show()
	waiting_label.hide()
	
	for asteroid in asteroids.get_children():
		asteroid.connect("exploded", _on_asteroid_exploded)
	
	this_scene_loaded = true

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Escape"):
		get_tree().change_scene_to_file("res://Scenes/menu_system.tscn")
		this_scene_loaded = false
	
	if playing_game == false:
		if Input.is_action_just_pressed("Space"):
			new_game()
		if Input.is_action_just_pressed("I"):
			instructions_label.visible = !instructions_label.visible
			game_over_label.visible = false
			space_start_label.visible = !space_start_label.visible
	
	if asteroids.get_child_count() == 0:
		do_next_level()
	
	if get_node("Music").playing == false and this_scene_loaded == true:
		await get_tree().create_timer(0.1).timeout
		get_node("Music").play()



func _on_player_shot_rocket(rocket):
	rockets.add_child(rocket)


func _on_teleport(value):
	teleport = value


func _on_asteroid_exploded(pos, size, points):
	score += points
	$RockSound.play()
	for i in range(2):
		match size:
			Asteroid.AsteroidSize.LARGE:
				spawn_asteroid(pos, Asteroid.AsteroidSize.MEDIUM)
			Asteroid.AsteroidSize.MEDIUM:
				spawn_asteroid(pos, Asteroid.AsteroidSize.SMALL)
			Asteroid.AsteroidSize.SMALL:
				pass


func _on_alien_exploded(points):
	score += points
	$AlienExplode.play()


func spawn_asteroid(pos, size):
	var asteroid = asteroid_scene.instantiate()
	asteroid.global_position = pos
	asteroid.size = size
	asteroid.connect("exploded", _on_asteroid_exploded)
	asteroids.call_deferred("add_child", asteroid)


func _on_player_died():
	lives -= 1
	player.global_position = spawn_point.global_position
	if lives <= 0:
		playing_game = false
		game_over_label.show()
		space_start_label.show()
	else:
		await get_tree().create_timer(1).timeout
		while !spawn_area.is_empty:
			waiting_label.show()
			await get_tree().create_timer(0.1).timeout
		waiting_label.hide()
		player.respawn(spawn_point.global_position)


func new_game():
	playing_game = true
	score = 0
	lives = 3
	level = 1
	player.new_game()
	player.respawn(spawn_point.global_position)
	game_over_label.hide()
	space_start_label.hide()
	for asteroid in asteroids.get_children():
		asteroid.queue_free()
	for alien in aliens.get_children():
		alien.queue_free()
	set_level_asteroids(base_number_asteroids + level)
	get_tree().create_timer(alien_timeout).timeout.connect(on_spawn_alien)


func set_level_asteroids(number):
	for i in number:
		var x = randi_range(50, 550)
		if x > 300:
			x += 200
		var y = randi_range(50, 350)
		if y > 200:
			y += 200
		spawn_asteroid(Vector2(x, y), Asteroid.AsteroidSize.LARGE)


func do_next_level():
	level += 1
	set_level_asteroids(base_number_asteroids + level)


func on_spawn_alien():
	var alien = alien_scene.instantiate()
	var x = randi_range(50, 550)
	if x > 300:
		x += 200
	var y = randi_range(50, 350)
	if y > 200:
		y += 200
	alien.global_position = Vector2(x, y)
	alien.connect("exploded", _on_alien_exploded)
	aliens.call_deferred("add_child", alien)
	get_tree().create_timer(alien_timeout).timeout.connect(on_spawn_alien)
