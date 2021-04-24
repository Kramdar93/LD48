extends Node

export (PackedScene) var baseBuilding

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass # todo: test area to determine if it is okay to build

func build():
	var newBuilding = baseBuilding.instance()
	get_parent().get_parent().add_child(newBuilding)
	newBuilding.position = get_parent().position
	# remove our whole root
	get_parent().get_parent().remove_child(get_parent())
	get_parent().queue_free()
	
func cancel():
	# remove our whole root
	get_parent().get_parent().remove_child(get_parent())
	get_parent().queue_free()

func _input(event):
	if event is InputEventMouseMotion:
		get_parent().position = event.position
	if event is InputEventMouseButton:
		print(event.button_index)
		if event.button_index == 1: # left click
			build()
		else: # idc
			cancel()
