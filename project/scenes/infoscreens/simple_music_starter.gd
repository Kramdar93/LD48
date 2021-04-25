extends Node


export var track = ""


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("/root/Game/Static/audio").play_music(track)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
