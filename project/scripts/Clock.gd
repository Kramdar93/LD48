extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var seconds_in_day = 30.0

var time_now = 0.0


# Called when the node enters the scene tree for the first time.
func _ready():
	print("Game clock path: " + get_path())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_now += delta
	if time_now > seconds_in_day:
		time_now -= seconds_in_day

func get_in_game_time():
	return time_now
