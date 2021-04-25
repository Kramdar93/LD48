extends Button

export var amount = 2.0

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("pressed", self, "_button_pressed")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _button_pressed():
	var map = get_node("/root/Game/map")
	var new_scale = map.scale * amount
	if new_scale.x > 0 and new_scale.y > 0:
		map.scale = new_scale
		# fix lousy lines
		for child in map.get_children():
			if child is Line2D:
				child.width /= amount
