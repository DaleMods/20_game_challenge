extends CharacterBody2D

@onready var health_bar: ProgressBar = $Health

var spawn_internal_min: float = 2
var spawn_internal_max: float = 3
var health = 0
var dead = false

const SPEED = 100
const SCORE = 50


func _ready() -> void:
	health = 100
	health_bar.value = health
	get_tree().create_timer(1).timeout.connect(shoot_flak)


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


func shoot_flak():
	if dead == false:
		if position.y < 580 and get_node("/root/Game3/Player").is_dead() == false:
			var bullet_scene = preload("res://Scenes/Game3/enemy_flak.tscn")
			var new_bullet = bullet_scene.instantiate()
			new_bullet.position = position
			get_node("/root/Game3/World").add_child(new_bullet)
			get_node("FireCanon").play()
		get_tree().create_timer(1).timeout.connect(shoot_flak)


func explode():
	dead = true
	get_node("Health").hide()
	get_node("Gun1").hide()
	get_node("Gun2").hide()
	get_node("Ship").hide()
	get_node("DestroyedShip").show()
	get_node("Fire").emitting = true
	get_node("Smoke").emitting = true
	get_node("CollisionShape2D").disabled = true
	get_node("/root/Game3").increase_score(SCORE)
	get_tree().create_timer(2).timeout.connect(sink_stage1)


func sink_stage1():
	get_node("Fire").emitting = false
	get_node("Smoke").emitting = false
	get_node("AnimatedSprite2D").hide()
	get_node("DestroyedShip").hide()
	get_tree().create_timer(1).timeout.connect(sink_stage2)


func sink_stage2():
	queue_free()
