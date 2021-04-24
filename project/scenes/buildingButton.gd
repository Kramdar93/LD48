extends Button


export (PackedScene) var buildMenu

var menu

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("pressed", self, "_button_pressed")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func open_menu():
		menu = buildMenu.instance()
		get_parent().add_child(menu)
		print("added")
	
func close_menu():
		get_parent().remove_child(menu)
		menu.queue_free()
		menu = null
		print("removed")
	

func _button_pressed():
	if menu == null or !is_instance_valid(menu):
		open_menu()
	else:
		close_menu()
	
func _unhandled_input(event):
	pass # todo: hide menues on click out
