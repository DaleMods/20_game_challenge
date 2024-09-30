class_name Game9AudioManager
extends Node

@onready var audio_streams: Node = $AudioStreams
@onready var music_player: AudioStreamPlayer = $MusicPlayer
@onready var systems_manager: Game9SystemsManager = $".."

const Enums = preload("res://Game9/Systems/enums.gd")

var music_loop = false
var sound_bus_index = 2
var music_bus_index = 1


func initialise():
	systems_manager.changed_audio_master_mute.connect(update_master_mute)
	systems_manager.changed_audio_sound_volume.connect(update_sound_volume)
	systems_manager.changed_audio_music_volume.connect(update_music_volume)


func _process(_delta: float) -> void:
	if music_loop:
		if music_player.playing == false and music_player.stream != null:
			music_player.play()
	
	for stream in audio_streams.get_children():
		if stream.playing == false:
			stream.queue_free()


func play_music_file(file_name, loop):
	var file = ResourceLoader.load(file_name)
	play_music(file, loop)


func play_music(file, loop):
	if music_player.playing:
		music_player.stop()
	if file != null:
		music_player.bus = AudioServer.get_bus_name(music_bus_index)
		music_player.stream = file
		music_player.play()
		music_loop = loop


func play_sound_file(file_name):
	var file = ResourceLoader.load(file_name)
	play_sound(file)


func play_sound(file):
	var stream = AudioStreamPlayer.new()
	if file != null:
		if systems_manager.get_option(Enums.OPTION.audio_master_mute) == false and systems_manager.get_option(Enums.OPTION.audio_sound_volume) > 5:
			stream.stream = file
			stream.bus = AudioServer.get_bus_name(sound_bus_index)
			$AudioStreams.add_child(stream)
			stream.play()


func update_master_mute(state):
	bus_mute_state(sound_bus_index, state)
	bus_mute_state(music_bus_index, state)


func bus_mute_state(index, state):
	AudioServer.set_bus_mute(index, state)


func update_sound_volume(state):
	var volume = 20.0 * log(state / 50.0)
	AudioServer.set_bus_volume_db(sound_bus_index, volume)


func update_music_volume(state):
	var volume = 20.0 * log(state / 50.0)
	AudioServer.set_bus_volume_db(music_bus_index, volume)
