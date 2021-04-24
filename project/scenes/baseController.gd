extends Node

export (PackedScene) var baseBuilding

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func create_building(position):
	var newBuilding = baseBuilding.instance()
	get_parent().add_child(newBuilding)
	newBuilding.position = position
