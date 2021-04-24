extends Node2D

export var type = "empty"

export var sticky_y = false

var old_y

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("driver").set_type(type)
	old_y = global_position.y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(sticky_y):
		global_position.y = old_y
