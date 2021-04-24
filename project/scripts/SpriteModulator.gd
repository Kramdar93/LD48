extends Node

export var midday_color = Color(1.0,0.8,0.1)


# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_parent().find_node("sprites").get_children():
		child.modulate = midday_color


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
