class_name Game9Track
extends Node3D

signal player_lap

@onready var ai_path: Path3D = $AIPath
@onready var player_0_follow: PathFollow3D = $AIPath/Player0Follow
@onready var player_0_rabbit: Marker3D = $AIPath/Player0Follow/Player0Rabbit
@onready var player_1_follow: PathFollow3D = $AIPath/Player1Follow
@onready var player_1_rabbit: Marker3D = $AIPath/Player1Follow/Player1Rabbit
@onready var player_2_follow: PathFollow3D = $AIPath/Player2Follow
@onready var player_2_rabbit: Marker3D = $AIPath/Player2Follow/Player2Rabbit
@onready var player_3_follow: PathFollow3D = $AIPath/Player3Follow
@onready var player_3_rabbit: Marker3D = $AIPath/Player3Follow/Player3Rabbit

const Globals = preload("res://Game9/Systems/globals.gd")

var app_node: Node

func _ready():
	app_node = get_node(Globals.app_node_path)
	app_node.systems_manager.key_pressed.connect(_on_key_pressed)


func _on_start_finish_line_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		if body.name.contains("Player"):
			if body.get_parent().approaching_finish:
				body.get_parent().approaching_finish = false
				emit_signal("player_lap", body.get_parent())


func _on_pre_finish_line_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		body.get_parent().approaching_finish = true


func _on_key_pressed(key):
	if key == KEY_F4:
		$PreviewCamera3D.current = true
	if key == KEY_F5:
		$PreviewCamera3D.current = false
