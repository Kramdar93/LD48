extends Node


var type = "empty"
var is_enemy = false

var parent_building = null
var child_buildings = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_type(new_type):
	if type == "empty":
		if new_type == "fortification":
			type = new_type
			get_parent().get_node("sprite").frame = 4
		if new_type == "extractor":
			type = new_type
			get_parent().get_node("sprite").frame = 2
		if new_type == "sensor":
			type = new_type
			get_parent().get_node("sprite").frame = 3
