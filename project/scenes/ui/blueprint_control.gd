extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass # todo: test area to determine if it is okay to build

func build():
	get_parent().get_parent().get_node("baseController").create_building(get_parent().position)
	get_parent().queue_free()
	
func cancel():
	get_parent().queue_free()

func _input(event):
	if event is InputEventMouseMotion:
		get_parent().position = event.position
	if event is InputEventMouseButton:
		if event.button_index == 1: # left click
			build()
		else: # idc
			cancel()
