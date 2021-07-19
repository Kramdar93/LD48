extends Button

export var type = "set me"

export var credit_cost = 100

export var mineral_cost = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("pressed", self, "_button_pressed")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _button_pressed():
	var result = get_parent().get_parent().get_parent().get_node("baseController").submit_trade(0,0,0,-mineral_cost,-credit_cost)
	if result:
		get_parent().get_parent().get_node("driver").set_type(type)
	else:
		get_node("/root/Game/Static/audio").play_sfx("cancel")
	get_parent().remove()
