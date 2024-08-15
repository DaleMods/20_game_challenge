extends Area2D


const SPEED = 75


var is_refueling = false
var body_active: CharacterBody2D = null


func _ready() -> void:
	get_tree().create_timer(0.5).timeout.connect(flash_off)


func _physics_process(delta: float) -> void:
	position.y += SPEED * delta
	if position.y > 850:
		queue_free()
	if is_refueling and body_active != null:
		refuel()


func flash_off():
	get_node("Label").visible = false
	get_tree().create_timer(0.2).timeout.connect(flash_on)


func flash_on():
	get_node("Label").visible = true
	get_tree().create_timer(0.5).timeout.connect(flash_off)


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("refuel"):
		is_refueling = true
		body_active = body


func _on_body_exited(body: Node2D) -> void:
	if body == body_active:
		is_refueling = false
		body_active = null


func refuel():
	if body_active.has_method("refuel"):
		body_active.refuel()
