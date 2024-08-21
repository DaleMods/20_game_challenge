extends Node2D

signal reached_end
signal exit_top_left
signal exit_top_right
signal exit_bottom_left
signal exit_bottom_right

@onready var dynamic_items: Node = $DynamicItems
@onready var croc_timer: Timer = $CrocTimer

var pond_scene = preload("res://Scenes/Game6/pond.tscn")
var tar_scene = preload("res://Scenes/Game6/tar.tscn")
var campfire_scene = preload("res://Scenes/Game6/campfire.tscn")
var croc_scene = preload("res://Scenes/Game6/croc.tscn")
var log_scene = preload("res://Scenes/Game6/log.tscn")
var scorpio_scene = preload("res://Scenes/Game6/scorpio.tscn")
var snek_scene = preload("res://Scenes/Game6/snek.tscn")
var treasure_scene = preload("res://Scenes/Game6/treasure.tscn")
var vine_scene = preload("res://Scenes/Game6/vine.tscn")


func _ready() -> void:
	croc_timer.timeout.connect(croc_timer_check)


func setup_room(main_enemy, ground, scorpion, walls, treasure):
	for item in dynamic_items.get_children():
		item.queue_free()
	
	await get_tree().create_timer(0.1).timeout
	
	var vine = false
	
	$Ladder.visible = false
	
	$TopLeftWall/CollisionShape2D.disabled = true
	$TopLeftWall.visible = false
	
	$TopRightWall.visible = false
	$TopRightWall/CollisionShape2D.disabled = true
	
	$LeftWall.visible = false
	$LeftWall/CollisionShape2D.disabled = true
	
	$RightWall.visible = false
	$RightWall/CollisionShape2D.disabled = true
	
	$NoHoles.visible = false
	$"NoHoles/Surface-NoHoles/CollisionShape2D".disabled = true
	
	$OneHole.visible = false
	$"OneHole/Surface-OneHole/CollisionShape2D".disabled = true
	$"OneHole/Surface-OneHole/CollisionShape2D2".disabled = true
	
	$ThreeHoles.visible = false
	$"ThreeHoles/Surface-ThreeHoles/CollisionShape2D".disabled = true
	$"ThreeHoles/Surface-ThreeHoles/CollisionShape2D2".disabled = true
	$"ThreeHoles/Surface-ThreeHoles/CollisionShape2D3".disabled = true
	$"ThreeHoles/Surface-ThreeHoles/CollisionShape2D4".disabled = true
	
	if ground == 4:
		main_enemy = 0
	
	match main_enemy:
		0:
			# no enemy
			pass
		1:
			# one rolling log
			var item = log_scene.instantiate()
			item.global_position = Vector2(650, 350)
			dynamic_items.add_child(item)
		2:
			# two rolling logs
			var item1 = log_scene.instantiate()
			var item2 = log_scene.instantiate()
			item1.global_position = Vector2(650, 350)
			item2.global_position = Vector2(850, 350)
			dynamic_items.add_child(item1)
			dynamic_items.add_child(item2)
		3:
			# two rolling logs
			var item1 = log_scene.instantiate()
			var item2 = log_scene.instantiate()
			item1.global_position = Vector2(650, 350)
			item2.global_position = Vector2(850, 350)
			dynamic_items.add_child(item1)
			dynamic_items.add_child(item2)
			vine = true
		4:
			# three rolling logs
			var item1 = log_scene.instantiate()
			var item2 = log_scene.instantiate()
			var item3 = log_scene.instantiate()
			item1.global_position = Vector2(650, 350)
			item2.global_position = Vector2(850, 350)
			item3.global_position = Vector2(1050, 350)
			dynamic_items.add_child(item1)
			dynamic_items.add_child(item2)
			dynamic_items.add_child(item3)
			vine = true
		5:
			# one stationary log
			var item = log_scene.instantiate()
			item.global_position = Vector2(650, 350)
			item.can_roll = false
			dynamic_items.add_child(item)
		6:
			# three stationary logs
			var item1 = log_scene.instantiate()
			var item2 = log_scene.instantiate()
			var item3 = log_scene.instantiate()
			item1.global_position = Vector2(450, 350)
			item2.global_position = Vector2(650, 350)
			item3.global_position = Vector2(750, 350)
			item1.can_roll = false
			item2.can_roll = false
			item3.can_roll = false
			dynamic_items.add_child(item1)
			dynamic_items.add_child(item2)
			dynamic_items.add_child(item3)
		7: 
			# campfire
			var item = campfire_scene.instantiate()
			dynamic_items.add_child(item)
		8:
			# snake
			var item = snek_scene.instantiate()
			dynamic_items.add_child(item)
	
	match ground:
		0:
			# 1 hole with ladder
			$Ladder.visible = true
			$OneHole.visible = true
			$"OneHole/Surface-OneHole/CollisionShape2D".disabled = false
			$"OneHole/Surface-OneHole/CollisionShape2D2".disabled = false
		1:
			# 3 holes with ladder
			$Ladder.visible = true
			$ThreeHoles.visible = true
			$"ThreeHoles/Surface-ThreeHoles/CollisionShape2D".disabled = false
			$"ThreeHoles/Surface-ThreeHoles/CollisionShape2D2".disabled = false
			$"ThreeHoles/Surface-ThreeHoles/CollisionShape2D3".disabled = false
			$"ThreeHoles/Surface-ThreeHoles/CollisionShape2D4".disabled = false
		2:
			# no holes
			$NoHoles.visible = true
			$"NoHoles/Surface-NoHoles/CollisionShape2D".disabled = false
		3:
			# no holes
			$NoHoles.visible = true
			$"NoHoles/Surface-NoHoles/CollisionShape2D".disabled = false
		4:
			# crocs in water
			$NoHoles.visible = true
			$"NoHoles/Surface-NoHoles/CollisionShape2D".disabled = false
			var pond = pond_scene.instantiate()
			dynamic_items.add_child(pond)
			pond.enable_pond(false)
			var croc1 = croc_scene.instantiate()
			var croc2 = croc_scene.instantiate()
			var croc3 = croc_scene.instantiate()
			croc1.global_position = Vector2(325, 350)
			croc2.global_position = Vector2(400, 350)
			croc3.global_position = Vector2(475, 350)
			dynamic_items.add_child(croc1)
			dynamic_items.add_child(croc2)
			dynamic_items.add_child(croc3)
			if main_enemy == 3 or main_enemy == 4 or main_enemy == 7 or main_enemy == 8:
				vine = true
		5:
			# shifting tar with treasure
			$NoHoles.visible = true
			$"NoHoles/Surface-NoHoles/CollisionShape2D".disabled = false
			var tar = tar_scene.instantiate()
			dynamic_items.add_child(tar)
			tar.enable_tar()
		6: 
			# shifting tar no treasure
			$NoHoles.visible = true
			$"NoHoles/Surface-NoHoles/CollisionShape2D".disabled = false
			var tar = tar_scene.instantiate()
			dynamic_items.add_child(tar)
			tar.enable_tar()
			vine = true
		7:
			# shifting water
			$NoHoles.visible = true
			$"NoHoles/Surface-NoHoles/CollisionShape2D".disabled = false
			var pond = pond_scene.instantiate()
			dynamic_items.add_child(pond)
			pond.enable_pond(true)
	
	match scorpion:
		0:
			# no scorpion
			pass
		1:
			# one scorpion
			var item = scorpio_scene.instantiate()
			dynamic_items.add_child(item)
	
	match walls:
		0:
			# no wall
			pass
		1:
			# left wall
			$LeftWall.visible = true
			$LeftWall/CollisionShape2D.disabled = false
		2:
			# right wall
			$RightWall.visible = true
			$RightWall/CollisionShape2D.disabled = false
		3:
			# both walls
			$LeftWall.visible = true
			$LeftWall/CollisionShape2D.disabled = false
			$RightWall.visible = true
			$RightWall/CollisionShape2D.disabled = false
		4:
			# both left walls - only possible room 0
			$TopLeftWall.visible = true
			$TopLeftWall/CollisionShape2D.disabled = false
			$LeftWall.visible = true
			$LeftWall/CollisionShape2D.disabled = false
		5:
			# both right walls - only possible room 255
			$TopRightWall.visible = true
			$TopRightWall/CollisionShape2D.disabled = false
			$RightWall.visible = true
			$RightWall/CollisionShape2D.disabled = false
	
	match treasure:
		0:
			# no treasure
			pass
		1:
			# money treasure
			var item = treasure_scene.instantiate()
			dynamic_items.add_child(item)
			item.set_treasure(0)
			item.global_position = Vector2(600, 350)
		2:
			# silver treasure
			var item = treasure_scene.instantiate()
			dynamic_items.add_child(item)
			item.set_treasure(1)
			item.global_position = Vector2(600, 350)
		3:
			# gold treasure
			var item = treasure_scene.instantiate()
			dynamic_items.add_child(item)
			item.set_treasure(2)
			item.global_position = Vector2(600, 350)
		4:
			# ring treasure
			var item = treasure_scene.instantiate()
			dynamic_items.add_child(item)
			item.set_treasure(3)
			item.global_position = Vector2(600, 350)
		5:
			# money treasure underground
			var item = treasure_scene.instantiate()
			dynamic_items.add_child(item)
			item.set_treasure(0)
			item.global_position = Vector2(600, 520)
		6:
			# silver treasure underground
			var item = treasure_scene.instantiate()
			dynamic_items.add_child(item)
			item.set_treasure(1)
			item.global_position = Vector2(600, 520)
		7:
			# gold treasure underground
			var item = treasure_scene.instantiate()
			dynamic_items.add_child(item)
			item.set_treasure(2)
			item.global_position = Vector2(600, 520)
		8:
			# ring treasure underground
			var item = treasure_scene.instantiate()
			dynamic_items.add_child(item)
			item.set_treasure(3)
			item.global_position = Vector2(600, 520)
	
	croc_timer.stop()
	await get_tree().create_timer(0.1).timeout
	croc_timer.wait_time = 3.0
	croc_timer.start()
	
	if vine:
		var new_vine = vine_scene.instantiate()
		new_vine.vine_active = true
		dynamic_items.add_child(new_vine)


func _on_exit_top_left_body_entered(_body: Node2D) -> void:
	emit_signal("exit_top_left")


func _on_exit_top_right_body_entered(_body: Node2D) -> void:
	emit_signal("exit_top_right")


func _on_exit_bottom_left_body_entered(_body: Node2D) -> void:
	emit_signal("exit_bottom_left")


func _on_exit_bottom_right_body_entered(_body: Node2D) -> void:
	emit_signal("exit_bottom_right")


func croc_timer_check():
	dynamic_items.change_crocs()
	croc_timer.wait_time = 3.0
	croc_timer.start()


func remove_treasure():
	for item in dynamic_items.get_children():
		if item is Game6Treasure:
			item.queue_free()


func _on_top_right_wall_body_entered(body: Node2D) -> void:
	emit_signal("reached_end")


func end_game():
	dynamic_items.hold_enemy_positions()
