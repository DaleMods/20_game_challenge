extends Sprite2D


const SPEED = 100.0
const DAMAGE = 25

var direction: int
var velocity = Vector2(1,0)


func _ready() -> void:
	get_tree().create_timer(5).timeout.connect(bullet_timeout)


func _physics_process(delta: float) -> void:
	position += velocity * delta


func bullet_timeout():
	queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("damage_player"):
		body.damage_player(DAMAGE)
		queue_free()
