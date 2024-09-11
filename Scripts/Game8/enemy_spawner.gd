extends Node3D

var xwing_scene = preload("res://Scenes/Game8/xwing.tscn")
var atat_scene = preload("res://Scenes/Game8/atat_walker.tscn")
var bridge_scene = preload("res://Scenes/Game8/bridge.tscn")
var antenna_scene = preload("res://Scenes/Game8/antenna.tscn")
var boss_scene = preload("res://Scenes/Game8/cr_90.tscn")
var level_time := 0.0
var boss_time := 30.0


func _physics_process(delta: float) -> void:
	level_time += delta
	if get_parent().game_state == 5 and level_time >= boss_time:
		get_parent().game_state = 6


func spawn():
	if get_parent().game_state == 5:
		var objects = [xwing_scene, xwing_scene, xwing_scene, xwing_scene, xwing_scene, xwing_scene, atat_scene, bridge_scene, antenna_scene]
		var object = objects[randi_range(0,objects.size() - 1)].instantiate()
		add_child(object)
		object.transform.origin = transform.origin + Vector3(randf_range(-15, 15), randf_range(-15, 15), 0)
		object.on_shot.connect(on_object_shot)
	if get_parent().game_state == 6:
		var boss = boss_scene.instantiate()
		add_child(boss)
		boss.global_position = Vector3(-50, 0, 30)
		boss.rotation_degrees = Vector3(0, 180, 0)
		boss.on_shot.connect(on_boss_shot)
		get_parent().game_state = 7


func _on_timer_timeout() -> void:
	spawn()


func on_object_shot():
	get_parent().add_score(20)


func on_boss_shot():
	get_parent().add_score(100)
	get_parent().next_level()
