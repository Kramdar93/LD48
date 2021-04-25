extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var seconds_in_day = 30.0

var time_now = 0.0
var total_time = 0.0
var time_offset

# Called when the node enters the scene tree for the first time.
func _ready():
	time_offset = (6.0 / 24) * seconds_in_day # need to do this here, otherwise the default seconds in day will be used.
	print("Game clock path: " + get_path())
	print("Game time start: " + str(time_now))
	
# floating point error hell. Too bad!
func format_time(t, total):
	var game_days = t / seconds_in_day
	var game_hours = game_days * 24
	var game_minutes = game_hours * 60
	var game_seconds = game_minutes * 60
	if total:
		#if int(game_days) > 0:
		#	return str(int(game_days)) + "D " + str(int(game_hours % 24)).pad_zeros(2) + "H " + str(int(game_minutes % 60)).pad_zeros(2) + "M " + str(int(game_seconds % 60)).pad_zeros(2) + "S"
		#else:
		#	return str(int(game_hours) % 24).pad_zeros(2) + "H " + str(int(game_minutes) % 60).pad_zeros(2) + "M " + str(int(game_seconds) % 60).pad_zeros(2) + "S"
		if int(game_days) == 1:
			return str(int(game_days)) + " Day"
		else:
			return str(int(game_days)) + " Days"
	else:
		return str(int(game_hours) % 24).pad_zeros(2) + "H " + str(int(game_minutes) % 60).pad_zeros(2) + "M " + str(int(game_seconds) % 60).pad_zeros(2) + "S"

func update_clocks():
	var time = get_node("time")
	var tot_time = get_node("tot_time")
	if time != null and tot_time != null:
		time.update_text(format_time(time_now+time_offset, false), null)
		tot_time.update_text(format_time(total_time, true), null)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_now += delta
	total_time += delta
	if time_now > seconds_in_day:
		time_now -= seconds_in_day
	update_clocks()

func get_in_game_time():
	return time_now


