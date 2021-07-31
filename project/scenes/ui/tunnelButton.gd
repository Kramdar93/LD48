extends Button


export (PackedScene) var tunnelBlueprint

const tunnelCost = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	pressed = true
	connect("pressed", self, "_button_pressed")
	connect("mouse_entered", self, "_mouse_enter")
	connect("mouse_exited", self, "_mouse_exit")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _button_pressed():
	var result = get_parent().get_parent().get_parent().get_node("baseController").submit_trade(0,0,0,0,-tunnelCost)
	if result:
		var newTunnel = tunnelBlueprint.instance()
		newTunnel.get_node("Area2D").origin = get_parent().get_parent()
		get_parent().get_parent().get_node("driver").active_blueprint = newTunnel
		get_parent().get_parent().get_parent().add_child(newTunnel)
		get_node("/root/Game/Static/audio").play_sfx("get")
	else:
		get_node("/root/Game/Static/audio").play_sfx("cancel")
	get_parent().remove()

func _mouse_enter():
	get_node("cost").force_update("$"+str(tunnelCost),null)
	
func _mouse_exit():
	get_node("cost").force_update("",null)

func _input(event):
	if event is InputEventKey and event.is_pressed():
		# todo: do this properly... 
		var key = OS.get_scancode_string(event.scancode)
		if key == 'T':
			_button_pressed()
