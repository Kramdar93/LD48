extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func remove():
	# remove our whole root
	get_parent().remove_child(get_node("."))
	queue_free()
	
# uhh
func is_build_menu():
	return true
