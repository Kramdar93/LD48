extends Node

var real_time
var seconds_in_day
var credits_spent
var credits_earned

var total_oxy_mined = 0
var total_water_mined = 0
var total_food_mined = 0
var total_mineral_mined = 0

var total_enemies_killed = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	OS.set_window_maximized(true)
