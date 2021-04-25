extends Node2D


export var type = "none"

export var amount = 1

func _ready():
	if type == "oxygen":
		get_node("sprite").frame = 12
	elif type == "water":
		get_node("sprite").frame = 10
	elif type == "food":
		get_node("sprite").frame = 11
	elif type == "mineral":
		get_node("sprite").frame = 9

func get_type():
	return type
