class_name Game9Tree
extends Node3D

@onready var up_collider: RayCast3D = $UpCollider
@onready var down_collider: RayCast3D = $DownCollider

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
	if up_collider.is_colliding():
		queue_free()
		return
	if down_collider.is_colliding():
		var collider = down_collider.get_collider()
		if collider.name == "Floor" or collider is Game9GroundBase:
			return
		queue_free()
