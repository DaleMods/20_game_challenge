extends Sprite2D


const SPEED = 200.0
const DISTANCE = 250.0
const DAMAGE = 25


var target = Vector2(0,0)
var origin = Vector2(0,0)
var exploded = false

func _ready() -> void:
	target = get_node("/root/Game3/Player").position
	origin = position


func _physics_process(delta: float) -> void:
	if exploded:
		if get_node("FlakExplosion").emitting == false:
			queue_free()
		return
	position = position.move_toward(target, delta * SPEED)
	if position.distance_to(origin) >= DISTANCE:
		do_explosion()
	if position == target:
		do_explosion()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("damage_player") and exploded == false:
		body.damage_player(DAMAGE)
		do_explosion()


func do_explosion():
	exploded = true
	get_node("FlakExplosion").emitting = true

