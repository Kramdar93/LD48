extends Node

#export var morning_color = Color(1.0,0.5,0.1,1.0)

#export var midday_color = Color(1.0,0.8,0.1,1.0)

#export var evening_color = Color(1.0,0.5,0.1,1.0)

#export var night_color = Color(0.0,0.0,0.0,1.0)

export (Array, Color) var colors = []
export (Array, float) var segments = []

var game_clock
var max_time
var real_segments = []

# Called when the node enters the scene tree for the first time.
func _ready():
	game_clock = get_node("/root/Game/Static/Clock")
	if game_clock == null:
		print("Cannot find game clock!")
	elif colors.size() != segments.size() or colors.size() == 0:
		print("Sprite Modulator not set up correctly! At: " + get_path())
	else:
		print("Game clock found: "+game_clock.get_path())
		max_time = game_clock.seconds_in_day
		for i in range(segments.size()):
			real_segments.append(segments[i] * game_clock.seconds_in_day)
			print(real_segments[i])
		set_child_color()

func get_slerp(start, now, end):
	if start > end:
		start -= max_time
	return (now-start)/(end-start)

func set_child_color():
	if game_clock != null:
		var time = game_clock.get_in_game_time()
		var max_time = game_clock.seconds_in_day
		var color_now = colors[colors.size()-1]
		var prev_index
		for i in range(colors.size()):
			prev_index = (i-1) % colors.size()
			if time >= real_segments[prev_index] and time <= real_segments[i]:
				color_now = colors[prev_index].linear_interpolate(colors[i],get_slerp(real_segments[prev_index], time, real_segments[i]))
		for child in get_parent().find_node("sprites").get_children():
			child.modulate = color_now

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	set_child_color()
