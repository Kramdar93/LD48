extends Button

export var scene_to_load = "res://scenes/main_level.tscn"


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("pressed", self, "_button_pressed")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _button_pressed():
	get_tree().change_scene(scene_to_load)
