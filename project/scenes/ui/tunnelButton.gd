extends Button


export (PackedScene) var tunnelBlueprint


# Called when the node enters the scene tree for the first time.
func _ready():
	pressed = true
	connect("pressed", self, "_button_pressed")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _button_pressed():
	var newTunnel = tunnelBlueprint.instance()
	get_parent().get_parent().get_parent().add_child(newTunnel)
	get_parent().remove()
