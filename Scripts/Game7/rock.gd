class_name Game7Rock
extends StaticBody2D

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready() -> void:
	$Rock/CollisionPolygon2D.polygon = $Rock/Polygon2D.polygon


func clip(poly):
	var offset_poly = Polygon2D.new()
	
	offset_poly.polygon = poly.global_transform * poly.polygon
	var result = Geometry2D.clip_polygons($Rock/Polygon2D.global_transform * $Rock/Polygon2D.polygon, offset_poly.polygon)
	
	$Rock/Polygon2D.polygon = result[0]
	$Rock/CollisionPolygon2D.set_deferred("polygon", result[0])
	
	offset_poly.queue_free()


func explode():
	$Rock/Polygon2D.visible = false
	$Rock/Explosion.emitting = true
	await get_tree().create_timer(3.5).timeout
	queue_free()
