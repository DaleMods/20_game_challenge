extends Node

var calc_angle = -135
var calc_speed = 0.75
var last_angle = -135
var last_speed = 0.75

var done_calculating = false
var short = false


func do_ai_turn():
	if done_calculating == false:
		last_angle = calc_angle
		last_speed = calc_speed
		
		if short:
			calc_speed += randf_range(0.05, 0.1)
#			calc_angle -= 2.5
		else:
			calc_speed -= randf_range(0.05, 0.1)
#			calc_angle += 2.5
		
		done_calculating = true


func update_ai_with_projectile_values(end_position):
	var player_other_pos = get_parent().get_parent().players[0].global_position
	
	if end_position.x > player_other_pos.x:
		short = true
	else:
		short = false
