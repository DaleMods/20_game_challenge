class_name Game9GroundBase
extends Node3D

@onready var down_1_collider: RayCast3D = $Down1Collider
@onready var down_2_collider: RayCast3D = $Down2Collider
@onready var down_3_collider: RayCast3D = $Down3Collider
@onready var down_4_collider: RayCast3D = $Down4Collider
@onready var down_5_collider: RayCast3D = $Down5Collider

var count_cycles = 0
var check_collision = true

func _process(_delta):
	if count_cycles < 60:
		count_cycles += 1
	if check_collision:
		is_colliding_with()


func is_colliding_with():
	if count_cycles >= 60:
		check_collision = false
	if down_1_collider.is_colliding():
		var collider = down_1_collider.get_collider()
		if collider.name != "Floor":
			queue_free()
			return
	if down_2_collider.is_colliding():
		var collider = down_2_collider.get_collider()
		if collider.name != "Floor":
			queue_free()
			return
	if down_3_collider.is_colliding():
		var collider = down_3_collider.get_collider()
		if collider.name != "Floor":
			queue_free()
			return
	if down_4_collider.is_colliding():
		var collider = down_4_collider.get_collider()
		if collider.name != "Floor":
			queue_free()
			return
	if down_5_collider.is_colliding():
		var collider = down_5_collider.get_collider()
		if collider.name != "Floor":
			queue_free()
			return
