class_name Game6Treasure
extends CharacterBody2D

@onready var money: Sprite2D = $Money
@onready var silver: Sprite2D = $Silver
@onready var gold: Sprite2D = $Gold
@onready var ring: Sprite2D = $Ring

# Body Attributes:
var can_climb = false
var can_kill_harry = false
var can_roll = false
var can_shrink_expand = false
var is_temp_safe = false
var is_treasure = true


func set_treasure(state):
	if state == 0:
		money.visible = true
		silver.visible = false
		gold.visible = false
		ring.visible = false
	if state == 1:
		money.visible = false
		silver.visible = true
		gold.visible = false
		ring.visible = false
	if state == 2:
		money.visible = false
		silver.visible = false
		gold.visible = true
		ring.visible = false
	if state == 3:
		money.visible = false
		silver.visible = false
		gold.visible = false
		ring.visible = true
