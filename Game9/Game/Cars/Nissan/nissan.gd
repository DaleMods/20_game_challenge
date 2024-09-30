class_name Game9Nissan
extends VehicleBody3D

@onready var camera_pivot: Node3D = $CameraPivot
@onready var follow_camera: Camera3D = $CameraPivot/FollowCamera
@onready var reverse_camera: Camera3D = $CameraPivot/ReverseCamera
@onready var side_camera: Camera3D = $CameraPivot/SideCamera

const MAX_STEER = 0.5
const ENGINE_POWER = 300
const Globals = preload("res://Game9/Systems/globals.gd")

var app_node: Node
var look_at_car
var side_camera_active = false
var player_num
var distance_moved: float = 0.0
var speed_kmh: float = 0.0
var starting_state = false
var can_move = false
var approaching_finish = false
var race_finished = false
var motor_rpm: float = 1000.0
var path: Path3D
var follow: PathFollow3D
var rabbit: Marker3D
var track_variance: Vector3 = Vector3.ZERO


func _ready() -> void:
	look_at_car = global_position
	app_node = get_node(Globals.app_node_path)
	app_node.systems_manager.key_pressed.connect(_on_key_pressed)
	app_node.ui_manager.game_ui.race_is_go.connect(_on_race_is_go)
	app_node.ui_manager.game_ui.race_is_done.connect(_on_race_is_done)


func setup_player_camera():
	reverse_camera.current = true
	starting_state = true
	camera_pivot.rotate(Vector3.UP, deg_to_rad(-179))


func _physics_process(delta: float):
	if starting_state and player_num == 0:
		camera_pivot.global_position = camera_pivot.global_position.lerp(global_position, delta * 20.0)
		camera_pivot.transform = camera_pivot.transform.interpolate_with(transform, delta * 1.5)
		look_at_car = global_position
		follow_camera.look_at(look_at_car)
		reverse_camera.look_at(look_at_car)
	
	if can_move:
		starting_state = false
		
		if player_num == 0:
			do_player_camera(delta)
			if race_finished == true:
				do_ai_driving(delta)
			else:
				do_player_driving(delta)
		else:
			do_ai_driving(delta)
	
	look_at_car = look_at_car.lerp(global_position + linear_velocity, delta * 5.0)
	distance_moved = global_position.distance_to(look_at_car)
	speed_kmh = linear_velocity.length() * 2.5
	
	do_simple_rpm_for_audio()


func do_player_camera(delta):
	camera_pivot.global_position = camera_pivot.global_position.lerp(global_position, delta * 20.0)
	camera_pivot.transform = camera_pivot.transform.interpolate_with(transform, delta * 5.0)
	follow_camera.look_at(look_at_car)
	reverse_camera.look_at(look_at_car)
	check_camera_switch()


func do_player_driving(delta):
	steering = move_toward(steering, Input.get_axis("D", "A") * MAX_STEER, delta)
	engine_force = Input.get_axis("S", "W") * ENGINE_POWER
	
	var offset = path.curve.get_closest_offset(path.to_local(global_position))
	follow.progress = offset


func do_ai_driving(delta):
	engine_force = ENGINE_POWER * 0.8 * randf_range(0.4, 1.0)
	
	var new_x = randf_range(-1, 1)
	var new_z = randf_range(-1, 1)
	
	track_variance.x += new_x
	track_variance.z += new_z
	if track_variance.x < -5:
		track_variance.x = 5
	if track_variance.x > 5:
		track_variance.x = 5
	if track_variance.z < -5:
		track_variance.z = 5
	if track_variance.z > 5:
		track_variance.z = 5
	
	var offset = path.curve.get_closest_offset(path.to_local(global_position))
	follow.progress = offset
	
	var target_pos = Vector3(rabbit.global_position.x, global_position.y, rabbit.global_position.z)
	target_pos += track_variance
	global_position = global_position.move_toward(target_pos, delta * 2)
	global_rotation = rabbit.global_rotation.lerp(global_rotation, delta * 5)


func do_simple_rpm_for_audio():
	if engine_force == 0:
		motor_rpm = 1000
		return
	
	var gear1_base_rpm = 1000.0
	var gear2_base_rpm = 2000.0
	var gear3_base_rpm = 3000.0
	var gear4_base_rpm = 4000.0
	var gear5_base_rpm = 5000.0
	var gear_max_rpm = 8000.0
	var gear1_max_speed = 20.0
	var gear2_max_speed = 40.0
	var gear3_max_speed = 80.0
	var gear4_max_speed = 160.0
	var gear5_max_speed = 280.0
	var gear_speed_ratio = 0.0
	
	if speed_kmh <= gear1_max_speed:
		gear_speed_ratio = speed_kmh
		motor_rpm = gear1_base_rpm + ((gear_max_rpm - gear1_base_rpm) / gear1_max_speed * gear_speed_ratio)
	if speed_kmh > gear1_max_speed and speed_kmh <= gear2_max_speed:
		gear_speed_ratio = speed_kmh - gear1_max_speed
		motor_rpm = gear2_base_rpm + ((gear_max_rpm - gear2_base_rpm) / (gear2_max_speed - gear1_max_speed) * gear_speed_ratio)
	if speed_kmh > gear2_max_speed and speed_kmh <= gear3_max_speed:
		gear_speed_ratio = speed_kmh - gear2_max_speed
		motor_rpm = gear3_base_rpm + ((gear_max_rpm - gear3_base_rpm) / (gear3_max_speed - gear2_max_speed) * gear_speed_ratio)
	if speed_kmh > gear3_max_speed and speed_kmh <= gear4_max_speed:
		gear_speed_ratio = speed_kmh - gear3_max_speed
		motor_rpm = gear4_base_rpm + ((gear_max_rpm - gear4_base_rpm) / (gear4_max_speed - gear3_max_speed) * gear_speed_ratio)
	if speed_kmh > gear4_max_speed and speed_kmh <= gear5_max_speed:
		gear_speed_ratio = speed_kmh - gear4_max_speed
		motor_rpm = gear5_base_rpm + ((gear_max_rpm - gear5_base_rpm) / (gear5_max_speed - gear4_max_speed) * gear_speed_ratio)
		
	if motor_rpm < 1000:
		motor_rpm = 1000


func check_camera_switch():
	if can_move and player_num == 0:
		if side_camera_active == true:
			side_camera.current = true
		else:
			if linear_velocity.dot(transform.basis.z) <= -0.1:
				follow_camera.current = true
			else:
				reverse_camera.current = true


func _on_key_pressed(key):
	if key == KEY_M:
		if side_camera_active:
			side_camera_active = false
		else:
			side_camera_active = true
			side_camera.current = true


func _on_race_is_go():
	can_move = true
	
	path = get_parent().current_track.ai_path
	match player_num:
		0:
			follow = get_parent().current_track.player_0_follow
			rabbit = get_parent().current_track.player_0_rabbit
		1:
			follow = get_parent().current_track.player_1_follow
			rabbit = get_parent().current_track.player_1_rabbit
		2:
			follow = get_parent().current_track.player_2_follow
			rabbit = get_parent().current_track.player_2_rabbit
		3:
			follow = get_parent().current_track.player_3_follow
			rabbit = get_parent().current_track.player_3_rabbit


func _on_race_is_done():
	race_finished = true
