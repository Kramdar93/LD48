extends Node2D


export var speed = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
	if event.is_action("ui_right"):
		position.x -= 12*speed
	if event.is_action("ui_left"):
		position.x += 12*speed
