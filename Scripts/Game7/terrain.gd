class_name Game7Terrain
extends Node2D

@onready var objects: Node = $Objects

var cloud_scene = preload("res://Scenes/Game7/cloud.tscn")
var tree_scene = preload("res://Scenes/Game7/tree.tscn")
var rock_scene = preload("res://Scenes/Game7/rock.tscn")
var windsock_scene = preload("res://Scenes/Game7/windsock.tscn")
var polygon
var wind_speed = 0
var wind_direction = 0
var tree_upper_num = 2
var rock_upper_num = 2


func _physics_process(_delta: float) -> void:
	if randi_range(0, 1000) == 1:
		new_cloud(0)


func new_game():
	$Terrain/Polygon2D.polygon = polygon
	$Terrain/Line2D.points = polygon
	$Terrain/CollisionPolygon2D.polygon = polygon


func clear_objects():
	for object in objects.get_children():
		object.queue_free()


func new_terrain():
	clear_objects()
	var curve = Curve2D.new()
	var point_in = Vector2(-75, 0)
	var point_out = Vector2(75, 0)
	var left_x = -100
	var right_x = 900
	var step_x = 150
	var high_y = 400
	var mid_y = 475
	var low_y = 550
	var bottom_y = 800
	curve.add_point(Vector2(0, bottom_y), point_out, point_in)
	curve.add_point(Vector2(left_x, bottom_y), point_out, point_in)
	curve.add_point(Vector2(left_x, mid_y), point_in, point_out)
	
	var step = left_x + step_x
	while step < right_x:
		var rand_y = randi_range(high_y, low_y)
		if step >= 150 and step <= 650:
			for num in randi_range(0, tree_upper_num):
				new_tree(Vector2(step + randi_range(-30, 30), rand_y - 45))
			for num in randi_range(0, rock_upper_num):
				new_rock(Vector2(step + randi_range(-5, 5), rand_y - 15))
		curve.add_point(Vector2(step, rand_y), point_in, point_out)
		step += step_x
	
	curve.add_point(Vector2(right_x, mid_y), point_in, point_out)
	curve.add_point(Vector2(right_x, bottom_y), point_out, point_in)
	polygon = curve.get_baked_points()
	
	wind_speed = randi_range(0, 2)
	wind_direction = randi_range(0, 1)
	
	new_windsock()
	
	new_cloud(1)
	new_cloud(500)
	new_cloud(1000)
	new_cloud(1500)
	
	new_game()


func clip(poly):
	var offset_poly = Polygon2D.new()
	
	offset_poly.polygon = poly.global_transform * poly.polygon
	var result = Geometry2D.clip_polygons($Terrain/Polygon2D.polygon, offset_poly.polygon)
	
	$Terrain/Polygon2D.polygon = result[0]
	$Terrain/Line2D.points = result[0]
	$Terrain/CollisionPolygon2D.set_deferred("polygon", result[0])
	
	offset_poly.queue_free()


func new_windsock():
	var windsock = windsock_scene.instantiate()
	windsock.position = Vector2(400, 100)
	objects.add_child(windsock)
	windsock.configure_windsock(wind_direction, wind_speed)


func new_cloud(position_x):
	var cloud = cloud_scene.instantiate()
	objects.add_child(cloud)
	cloud.configure_cloud(wind_direction, wind_speed)
	if position_x > 0:
		if wind_direction == 0:
			position_x *= -1
		cloud.global_position.x = position_x


func new_tree(tree_pos):
	var tree = tree_scene.instantiate()
	tree.global_position = tree_pos
	objects.add_child(tree)


func new_rock(rock_pos):
	var rock = rock_scene.instantiate()
	rock.global_position = rock_pos
	objects.add_child(rock)
