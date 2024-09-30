class_name Game9GameSetup
extends Control

@onready var racers_num: Label = $RaceOptions/VBoxContainer/Racers/RacersNum
@onready var racers_minus: Button = $RaceOptions/VBoxContainer/Racers/RacersMinus
@onready var racers_plus: Button = $RaceOptions/VBoxContainer/Racers/RacersPlus
@onready var laps_num: Label = $RaceOptions/VBoxContainer/Laps/LapsNum
@onready var laps_minus: Button = $RaceOptions/VBoxContainer/Laps/LapsMinus
@onready var laps_plus: Button = $RaceOptions/VBoxContainer/Laps/LapsPlus
@onready var prev_track: Button = $TrackSelect/VBoxContainer/HBoxContainer/PrevTrack
@onready var next_track: Button = $TrackSelect/VBoxContainer/HBoxContainer/NextTrack
@onready var track_name: Label = $TrackSelect/VBoxContainer/TrackName
@onready var track_num: Label = $TrackSelect/VBoxContainer/HBoxContainer/TrackNum
@onready var track_diff: Label = $TrackSelect/VBoxContainer/HBoxContainer/TrackDiff
@onready var track_map: TextureRect = $TrackSelect/VBoxContainer/TrackMap

const Enums = preload("res://Game9/Systems/enums.gd")
const Globals = preload("res://Game9/Systems/globals.gd")

var app_node: Node
var num_racers: int = 4
var num_laps: int = 5
var num_track: int = 1
var max_racers: int = 4
var max_laps: int = 10
var max_tracks: int = 5


func _ready() -> void:
	app_node = get_node(Globals.app_node_path)
	check_buttons()


func _on_back_pressed() -> void:
	app_node.systems_manager.play_sound_file(Globals.menu_click_sound)
	app_node.show_menu()


func _on_start_pressed() -> void:
	app_node.systems_manager.play_sound_file(Globals.menu_click_sound)
	app_node.new_game(num_track - 1, num_racers, num_laps)


func check_buttons():
	if num_racers == 1:
		racers_minus.disabled = true
	else:
		racers_minus.disabled = false
	
	if num_racers == max_racers:
		racers_plus.disabled = true
	else:
		racers_plus.disabled = false
	
	if num_laps == 2:
		laps_minus.disabled = true
	else:
		laps_minus.disabled = false
	
	if num_laps == max_laps:
		laps_plus.disabled = true
	else:
		laps_plus.disabled = false
	
	if num_track == 1:
		prev_track.disabled = true
	else:
		prev_track.disabled = false
	
	if num_track == max_tracks:
		next_track.disabled = true
	else:
		next_track.disabled = false
	
	racers_num.text = str(num_racers)
	laps_num.text = str(num_laps)
	track_num.text = str(num_track)
	if num_track == 1:
		track_name.text = "Rosedale Speedway"
		track_diff.text = "Easy"
		track_diff.add_theme_color_override("font_color", Color("00ff00"))
	if num_track == 2:
		track_name.text = "Figure Eight"
		track_diff.text = "Easy"
		track_diff.add_theme_color_override("font_color", Color("00ff00"))
	if num_track == 3:
		track_name.text = "Sandown Intl Raceway"
		track_diff.text = "Mid"
		track_diff.add_theme_color_override("font_color", Color("ffff00"))
	if num_track == 4:
		track_name.text = "Albert Park F1 Circuit"
		track_diff.text = "Mid"
		track_diff.add_theme_color_override("font_color", Color("ffff00"))
	if num_track == 5:
		track_name.text = "Mount Panarama"
		track_diff.text = "Hard"
		track_diff.add_theme_color_override("font_color", Color("ff0000"))
	
	track_map.texture = load("res://Game9/UI/GameSetup/track" + str(num_track) + ".png")


func _on_racers_minus_pressed() -> void:
	app_node.systems_manager.play_sound_file(Globals.menu_click_sound)
	if num_racers > 1:
		num_racers -= 1
	check_buttons()


func _on_racers_plus_pressed() -> void:
	app_node.systems_manager.play_sound_file(Globals.menu_click_sound)
	if num_racers < max_racers:
		num_racers += 1
	check_buttons()


func _on_laps_minus_pressed() -> void:
	app_node.systems_manager.play_sound_file(Globals.menu_click_sound)
	if num_laps > 2:
		num_laps -= 1
	check_buttons()


func _on_laps_plus_pressed() -> void:
	app_node.systems_manager.play_sound_file(Globals.menu_click_sound)
	if num_laps < max_laps:
		num_laps += 1
	check_buttons()


func _on_prev_track_pressed() -> void:
	app_node.systems_manager.play_sound_file(Globals.menu_click_sound)
	if num_track > 1:
		num_track -= 1
	check_buttons()


func _on_next_track_pressed() -> void:
	app_node.systems_manager.play_sound_file(Globals.menu_click_sound)
	if num_track < max_tracks:
		num_track += 1
	check_buttons()
