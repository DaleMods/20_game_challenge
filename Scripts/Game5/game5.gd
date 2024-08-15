extends Node2D

@onready var level: Node = $Level
@onready var players: Node = $Players
@onready var ghosts: Node = $Ghosts
@onready var fruits: Node = $Fruits
@onready var background_music: AudioStreamPlayer2D = $BackgroundMusic
@onready var intro_music: AudioStreamPlayer2D = $IntroMusic
@onready var level_complete_music: AudioStreamPlayer2D = $LevelCompleteMusic
@onready var ui: Control = $UI
@onready var game_over_label: Label = $UI/GameOver
@onready var space_to_play: Label = $UI/SpaceToPlay
@onready var extra_life_music: AudioStreamPlayer2D = $ExtraLifeMusic

# Game State:
# 0 - scene loaded, in "demo"
# 1 - intro music playing
# 2 - in game
# 3 - level complete
# 4 - game over playing
var game_state = 0

var pellets_eaten = 0:
	set(value):
		pellets_eaten = value

var lives = 3:
	set(value):
		lives = value
		ui.init_lives(lives)

var current_level = 0:
	set(value):
		current_level = value

var score := 0:
	set(value):
		score = value
		ui.score = value

var active_level: Node2D = null
var this_scene_loaded = false
var starting_game = false
var level_transitioning = false
var life_score_check = 0


func _ready() -> void:
	this_scene_loaded = true
	active_level = level.load_level(0)
	ghosts.spawn_ghosts(level, active_level)
	background_music.play()
	flash_spacestart_text()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Escape"):
		get_tree().change_scene_to_file("res://Scenes/menu_system.tscn")
		this_scene_loaded = false
	
	if game_state == 0:
		if Input.is_action_just_pressed("Space"):
			starting_game = true
			new_game()
		if background_music.playing == false:
			background_music.play()
	
	if game_state == 1:
		if intro_music.playing == false:
			game_state = 2
			pellets_eaten = 0
			players.spawn_player(level, active_level)
			ghosts.spawn_ghosts(level, active_level)
			level.start_game()
	
	if game_state == 2 and level_transitioning == false:
		if life_score_check >= 10000:
			extra_life_music.play()
			lives += 1
			life_score_check = 0
		if pellets_eaten == 70 or pellets_eaten == 170:
			fruits.spawn_fruit(current_level)
		if (active_level.get_num_pellets() - pellets_eaten) == 0:
			level_transitioning = true
			level.level_complete()
			if level_complete_music.playing == false:
				level_complete_music.play()
				await get_tree().create_timer(5.2).timeout
				game_state = 3
				current_level += 1
				if current_level >= level.level_scenes.size():
					current_level = 0

	if game_state == 3:
		if level_complete_music.playing == false:
			game_state = 2
			pellets_eaten = 0
			active_level = level.load_level(current_level)
			players.spawn_player(level, active_level)
			ghosts.spawn_ghosts(level, active_level)
			level_transitioning = false


func new_game():
	ghosts.remove_ghosts()
	current_level = 0
	active_level = level.load_level(current_level)
	game_over_label.hide()
	space_to_play.hide()
	score = 0
	lives = 3
	var tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	tween.tween_property(background_music, "volume_db", -80.0, 1.0)
	await get_tree().create_timer(1).timeout
	intro_music.play()
	game_state = 1
	starting_game = false


func life_lost():
	lives -= 1
	if lives == 0:
		game_over()
	else:
		await get_tree().create_timer(0.2).timeout
		level.reset_chase_scatter_state()
		ghosts.spawn_ghosts(level, active_level)
		players.spawn_player(level, active_level)


func game_over():
	game_state = 4
	await get_tree().create_timer(1).timeout
	game_state = 0
	flash_gameover_text()
	flash_spacestart_text()
	background_music.volume_db = 0
	background_music.play()
	players.end_game()
	ghosts.release_ghosts()


func flash_gameover_text():
	if game_state == 0 and starting_game == false:
		game_over_label.visible = !game_over_label.visible
		get_tree().create_timer(0.5).timeout.connect(flash_gameover_text)
	else:
		game_over_label.hide()


func flash_spacestart_text():
	if game_state == 0 and starting_game == false:
		space_to_play.visible = !space_to_play.visible
		get_tree().create_timer(0.5).timeout.connect(flash_spacestart_text)
	else:
		space_to_play.hide()


func add_score(value, pos):
	score += value
	life_score_check += value
	if pos != Vector2.ZERO:
		ui.do_score_label(value, pos)
