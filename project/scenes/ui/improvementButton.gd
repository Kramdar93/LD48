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
		var building = get_parent().get_parent()
		building.get_node("driver").set_type(type)
		get_parent().remove()
		building.get_node("Button")._button_pressed()
	else:
		get_node("/root/Game/Static/audio").play_sfx("cancel")

func get_cost():
	var result = ""
	if(credit_cost > 0):
		result += "$" + str(credit_cost) + " "
	if(mineral_cost > 0):
		result += "M" + str(mineral_cost) + " "
	return result
	
func _mouse_enter():
	if(type == "sensor"):
		get_parent().get_parent().get_node("light").scale = init_scale * 10
	get_node("cost").force_update(get_cost(),null)
	
func _mouse_exit():
	if(type == "sensor"):
		get_parent().get_parent().get_node("light").scale = init_scale
	get_node("cost").force_update("",null)
	
func _input(event):
	if event is InputEventKey and event.is_pressed():
		# todo: do this properly... 
		var key = OS.get_scancode_string(event.scancode)
		if key == 'E' and type == "extractor":
			_button_pressed()
		elif key == 'R' and type == "sensor":
			_button_pressed()
		elif key == 'F' and type == "fortification":
			_button_pressed()
