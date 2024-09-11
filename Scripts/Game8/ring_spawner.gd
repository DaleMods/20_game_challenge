extends Node3D

var ring_scene = preload("res://Scenes/Game8/ring.tscn")
var container_scene = preload("res://Scenes/Game8/container.tscn")


func spawn():
	if get_parent().game_state == 5:
		var objects = [ring_scene, ring_scene, ring_scene, container_scene]
		var object = objects[randi_range(0,objects.size() - 1)].instantiate()
		add_child(object)
		object.transform.origin = transform.origin + Vector3(randf_range(-5, 5), randf_range(-5, 5), 0)
		if object is Game8Ring:
			object.player_through_ring.connect(on_player_through_ring)
		if object is Game8Container:
			object.player_container.connect(on_player_container)


func _on_timer_timeout() -> void:
	spawn()


func on_player_through_ring():
	get_parent().add_score(10)
	$Score.play()


func on_player_container():
	$"../Player".been_repaired()
	$Score.play()
