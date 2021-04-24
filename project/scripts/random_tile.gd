extends Node

func _ready():
	var sprite = get_parent().find_node("sprite")
	sprite.frame = randi() % (sprite.hframes * sprite.vframes)
