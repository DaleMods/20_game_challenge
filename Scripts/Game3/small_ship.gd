extends CharacterBody2D

@onready var health_bar: ProgressBar = $Health

var health = 0
var dead = false

const SPEED = 50
const SCORE = 10


func _ready() -> void:
	health = 100
	health_bar.value = health


func _physics_process(delta: float) -> void:
	if health <= 0 and dead == false:
		explode()
	
	position.y += SPEED * delta
	if position.y > 800:
		queue_free()

	move_and_slide()


func torpedoed(damage):
	health -= damage
	if health < 0:
		health = 0
	health_bar.value = health
	get_node("Ship").modulate = Color.RED
	get_tree().create_timer(0.1).timeout.connect(reset_modulate)


func reset_modulate():
	get_node("Ship").modulate = Color.WHITE


func explode():
	dead = true
	get_node("Health").hide()
	get_node("Ship").hide()
	get_node("DestroyedShip").show()
	get_node("Fire").emitting = true
	get_node("Smoke").emitting = true
	get_node("CollisionShape2D").disabled = true
	get_node("/root/Game3").increase_score(SCORE)
	get_tree().create_timer(1).timeout.connect(sink_stage1)


func sink_stage1():
	get_node("Fire").emitting = false
	get_node("Smoke").emitting = false
	get_node("AnimatedSprite2D").hide()
	get_node("DestroyedShip").hide()
	get_tree().create_timer(1).timeout.connect(sink_stage2)


func sink_stage2():
	queue_free()
