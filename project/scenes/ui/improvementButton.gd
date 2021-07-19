extends Button

export var type = "set me"

export var credit_cost = 100

export var mineral_cost = 1

var init_scale = Vector2(1.0,1.0);

# Called when the node enters the scene tree for the first time.
func _ready():
	init_scale = get_parent().get_parent().get_node("light").scale
	connect("pressed", self, "_button_pressed")
	# godot please pick one signal name and stick with it.
	if(type == "sensor"):
		connect("mouse_entered", self, "_mouse_enter")
		connect("mouse_exited", self, "_mouse_exit")


# Called every frame. 'delta' is the elapsed time since the previous frame.
# assume button script
#func _process(delta):
#	if is_hovered():
#		get_parent().get_parent().get_node("light").scale = init_scale * 10
#	else:
#		get_parent().get_parent().get_node("light").scale = init_scale

func _button_pressed():
	get_parent().get_parent().get_node("light").scale = init_scale
	var result = get_parent().get_parent().get_parent().get_node("baseController").submit_trade(0,0,0,-mineral_cost,-credit_cost)
	if result:
		get_parent().get_parent().get_node("driver").set_type(type)
	else:
		get_node("/root/Game/Static/audio").play_sfx("cancel")
	get_parent().remove()

func _mouse_enter():
	get_parent().get_parent().get_node("light").scale = init_scale * 10
	
func _mouse_exit():
	get_parent().get_parent().get_node("light").scale = init_scale
	
