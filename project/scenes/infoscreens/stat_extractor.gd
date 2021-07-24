extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func convert_time(t, s_in_d):
	var game_days
	var game_hours
	var game_minutes
	var game_seconds
	if s_in_d == null: # more accurate to do it this way
		game_seconds = t
		game_minutes = game_seconds/60
		game_hours = game_minutes/60
		game_days = game_hours/20
	else:
		game_days = t / s_in_d
		game_hours = game_days * 24
		game_minutes = game_hours * 60
		game_seconds = game_minutes * 60
	if int(game_days) > 0:
		return str(int(game_days)) + "D " + str(int(game_hours) % 24).pad_zeros(2) + "H " + str(int(game_minutes) % 60).pad_zeros(2) + "M " + str(int(game_seconds) % 60).pad_zeros(2) + "S"
	else:
		return str(int(game_hours) % 24).pad_zeros(2) + "H " + str(int(game_minutes) % 60).pad_zeros(2) + "M " + str(int(game_seconds) % 60).pad_zeros(2) + "S"

# Called when the node enters the scene tree for the first time.
func _ready():
	var stats = get_node_or_null("/root/Stats")
	if stats != null:
		get_node("/root/Game/time").update_text(convert_time(stats.real_time,null), null)
		get_node("/root/Game/game_time").update_text(convert_time(stats.real_time,stats.seconds_in_day), null)
		get_node("/root/Game/credits_spent").update_text(str(stats.credits_spent), null)
		get_node("/root/Game/credits_earned").update_text(str(stats.credits_earned), null)
		get_node("/root/Game/monsters_killed").update_text(str(stats.total_enemies_killed), null)
		get_node("/root/Game/oxygen_mined").update_text(str(stats.total_oxy_mined), null)
		get_node("/root/Game/water_mined").update_text(str(stats.total_water_mined), null)
		get_node("/root/Game/food_mined").update_text(str(stats.total_food_mined), null)
		get_node("/root/Game/minerals_mined").update_text(str(stats.total_mineral_mined), null)
		for child in stats.get_children():
			stats.remove_child(child)
			get_node("/root/Game/map").add_child(child)
			child.global_position = child.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
