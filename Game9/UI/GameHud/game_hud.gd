class_name Game9GameHud
extends Control

signal race_is_go
signal race_is_done

@onready var lap_number: Label = $VBoxContainer/LapContainer/LapNumber
@onready var lap_total: Label = $VBoxContainer/LapContainer/LapTotal
@onready var speed_counter: Label = $VBoxContainer/SpeedContainer/SpeedCounter
@onready var position_number: Label = $PositionContainer/PositionNumber
@onready var position_total: Label = $PositionContainer/PositionTotal
@onready var final_lap: Label = $FinalLap
@onready var space_exit: Label = $SpaceExit

var lap: int = 0:
	set(value):
		lap = value
		update_lap(lap)
	get:
		return lap

var total_laps: int = 5:
	set(value):
		total_laps = value
		update_total_laps(total_laps)

var car_position: int = 0:
	set(value):
		car_position = value
		update_position(car_position)
	get:
		return car_position

var total_positions: int = 4:
	set(value):
		total_positions = value
		update_total_positions(total_positions)

var speed: int = 0:
	set(value):
		speed = value
		update_speed(speed)


func update_lap(lap_num):
	lap_number.text = str(lap_num)
	if lap == total_laps:
		final_lap.visible = true
	if lap > total_laps:
		final_lap.text = "Race Finished!"
		emit_signal("race_is_done")
		space_exit.visible = true


func update_total_laps(total_laps_num):
	lap_total.text = str(total_laps_num)


func update_position(position_num):
	position_number.text = str(position_num)


func update_total_positions(total_positions_num):
	position_total.text = str(total_positions_num)


func update_speed(speed_num):
	speed_counter.text = str(speed_num)


func start_race():
	$"3".visible = true
	await get_tree().create_timer(1.0).timeout
	$"3".visible = false
	$"2".visible = true
	await get_tree().create_timer(1.0).timeout
	$"2".visible = false
	$"1".visible = true
	await get_tree().create_timer(1.0).timeout
	$"1".visible = false
	$"GO".visible = true
	emit_signal("race_is_go")
	await get_tree().create_timer(2.0).timeout
	$"GO".visible = false
