extends Control

@onready var player_label: Label = $VBoxContainer/Player
@onready var shoot_label: Label = $VBoxContainer/Shoot

func _ready() -> void:
	visible = false


func new_game():
	visible = true
	$VBoxContainer.visible = false
	$Panel.visible = true


func _on_begin_pressed() -> void:
	visible = false
	$VBoxContainer.visible = true
	$Panel.visible = false
	show_player(1)


func show_player(player_num):
	visible = true
	player_label.text = "PLAYER " + str(player_num)
	shoot_label.text = "READY..."
	await get_tree().create_timer(2.0).timeout
	shoot_label.text = "SHOOT!"
	await get_tree().create_timer(0.5).timeout
	visible = false
	$"../Players".ui_finished()
