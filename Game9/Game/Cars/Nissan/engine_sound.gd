extends AudioStreamPlayer3D

@export var vehicle : Game9Nissan
@export var sample_rpm := 4000.0


func _ready():
	pitch_scale = (1000 / sample_rpm)


func _physics_process(delta):
	pitch_scale = lerp(pitch_scale, vehicle.motor_rpm / sample_rpm, delta * 4)
