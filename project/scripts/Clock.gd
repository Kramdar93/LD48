extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var seconds_in_day = 30.0

export (PackedScene) var oxygen_timeout
export (PackedScene) var water_timeout
export (PackedScene) var food_timeout

var time_now = 0.0
var total_time = 0.0
var time_offset
var seconds_in_hour

var known_bases = []

var active_timers = []

var can_play_music = true

# Called when the node enters the scene tree for the first time.
func _ready():
	time_offset = (6.0 / 24) * seconds_in_day # need to do this here, otherwise the default seconds in day will be used.
	seconds_in_hour = 1.0/24.0 * seconds_in_day
	print("Game clock path: " + get_path())
	print("Game time start: " + str(time_now))
	get_node("/root/Game/Static/audio").start_ambience()
	
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
	for timer in active_timers:
		get_node("cd_"+timer).update_text(format_time(seconds_in_day - time_now, false), Color(1,0,0))

func tick_bases():
	for base in known_bases:
		base.submit_trade(-1,-1,-1,0,0)
		
func check_timeouts():
	if len(active_timers) > 0:
		# just do the first one idc
		var type = active_timers[0]
		if type == "oxygen":
			get_tree().change_scene("res://scenes/infoscreens/oxy_go.tscn")
		elif type == "water":
			get_tree().change_scene("res://scenes/infoscreens/water_go.tscn")
		elif type == "food":
			get_tree().change_scene("res://scenes/infoscreens/food_go.tscn")
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_now += delta
	total_time += delta
	if time_now > seconds_in_day:
		check_timeouts()
		time_now -= seconds_in_day
		tick_bases()
	update_clocks()
	if time_now > seconds_in_day - seconds_in_hour:
		get_node("/root/Game/Static/audio").start_alarm()
	else:
		get_node("/root/Game/Static/audio").stop_alarm()
	# play a tune weekly
	if int(total_time/seconds_in_day) % 7 == 0 and can_play_music:
		get_node("/root/Game/Static/audio").play_music("interlude")
		can_play_music = false
	elif int(total_time/seconds_in_day) % 7 == 1:
		can_play_music = true

func get_in_game_time():
	return time_now

func registerBase(base):
	known_bases.append(base) # all ur base r belong to me

func showCountdown(type):
	if not active_timers.has(type):
		active_timers.append(type)
		get_node("cd_"+type).update_text(format_time(seconds_in_day - time_now, false), Color(1,0,0))

func clearTimer(type):
	# ugh
	while active_timers.has(type):
		active_timers.erase(type)
	get_node("cd_"+type).update_text("", Color(1,0,0))
	#if len(active_timers) == 0:
	#	get_node("/root/Game/Static/audio").stop_alarm()
	
