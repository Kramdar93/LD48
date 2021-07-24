extends Node

func _ready():
	var sprite = get_parent().get_node("sprites/sprite")
	sprite.frame = randi() % (sprite.hframes * sprite.vframes)
