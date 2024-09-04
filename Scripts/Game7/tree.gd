class_name Game7Tree
extends StaticBody2D

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready() -> void:
	$Tree/CollisionPolygon2D.polygon = $Tree/Polygon2D.polygon


func clip(poly):
	var offset_poly = Polygon2D.new()
	
	offset_poly.polygon = poly.global_transform * poly.polygon
	var result = Geometry2D.clip_polygons($Tree/Polygon2D.global_transform * $Tree/Polygon2D.polygon, offset_poly.polygon)
	
	$Tree/Polygon2D.polygon = result[0]
	$Tree/CollisionPolygon2D.set_deferred("polygon", result[0])
	
	offset_poly.queue_free()


func explode():
	$Tree/Polygon2D.visible = false
	$Tree/Explosion.emitting = true
	await get_tree().create_timer(3.5).timeout
	queue_free()
