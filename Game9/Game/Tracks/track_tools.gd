@tool
extends Path3D

@export_range(0, 2000) var tree_count = 1:
	set (value):
		tree_count = value
	get:
		return tree_count

@export_range(0, 2000) var base_count = 1:
	set (value):
		base_count = value
	get:
		return base_count

@export var mybutton: bool:
	set(value):
		spawn_trees()
		spawn_track_base()


var tree_scene = preload("res://Game9/Game/Scenery/Tree/tree.tscn")
var base_scene = preload("res://Game9/Game/Scenery/GroundBase/ground_base.tscn")

func spawn_trees():
	if !Engine.is_editor_hint():
		return
	var offsets = []
	var points = curve.get_baked_points()
	
	for child in $Trees.get_children():
		child.free()
	
	for i in range(tree_count):
		offsets.append(float(i)/float(tree_count + 1))
	
	for offset_idx in range(offsets.size()):
		var idx = clamp(int(points.size() * (offsets[offset_idx])), 0, points.size() - 1)
		var next_idx = clamp(int(points.size() * (offsets[0])), 0, points.size() - 1)
		if offset_idx + 1 < offsets.size():
			next_idx = clamp(int(points.size() * (offsets[offset_idx + 1])), 0, points.size() - 1)
		var point = points[idx]
		
		var item = Node3D.new()
		$Trees.add_child(item)
		
		var global_pos = point + global_position
		var next_global_pos = points[next_idx] + global_position
		item.global_position = global_pos
		
		var tree = tree_scene.instantiate()
		tree.name = "tree"
		item.add_child(tree)
		item.look_at(next_global_pos)
		
		var randLoc = randf_range(-10, 9)
		if randLoc < 0:
			randLoc -= 50
		if randLoc >= 0:
			randLoc += 17
		
		if randLoc < 0:
			item.translate(Vector3.LEFT * randLoc)
		else:
			item.translate(Vector3.LEFT * randLoc)
		
		var randRot = randf_range(-180, 180)
		item.rotate(Vector3(0, 1, 0), deg_to_rad(randRot))
		
		item.set_owner(get_tree().get_edited_scene_root())
		tree.set_owner(get_tree().get_edited_scene_root())


func spawn_track_base():
	if !Engine.is_editor_hint():
		return
	
	var points = curve.get_baked_points()
	var offsets = []
	
	for child in $Base.get_children():
		child.free()
	
	for i in range(base_count):
		offsets.append(float(i)/float(base_count + 1))
	
	for offset_idx in range(offsets.size()):
		var idx = clamp(int(points.size() * (offsets[offset_idx])), 0, points.size() - 1)
		var next_idx = clamp(int(points.size() * (offsets[0])), 0, points.size() - 1)
		if offset_idx + 1 < offsets.size():
			next_idx = clamp(int(points.size() * (offsets[offset_idx + 1])), 0, points.size() - 1)
		var point = points[idx]
		
		if point.y > 0:
			var item = Node3D.new()
			$Base.add_child(item)
			
			var global_pos = point + global_position
			var next_global_pos = points[next_idx] + global_position
			item.global_position = global_pos
			
			var base = base_scene.instantiate()
			base.name = "base"
			item.add_child(base)
			item.look_at(next_global_pos)
			
			item.set_owner(get_tree().get_edited_scene_root())
			base.set_owner(get_tree().get_edited_scene_root())
