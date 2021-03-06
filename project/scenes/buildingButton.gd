extends Button


export (PackedScene) var build_menu_scene

export (PackedScene) var tunnel_menu_scene

export (PackedScene) var shop_menu_scene

# apparently when objects are freed your reference switches to its parent???
# store path and lookup instead...
var build_menu_path = null

# kinda hacky but whatever
#var time_since_created = 0.0

var active = true

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("pressed", self, "_button_pressed")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#time_since_created += delta
	if(get_parent().get_node("driver").type == "port"):
		get_parent().global_position.x = get_node("/root/Game/base_deco").global_position.x
		if(get_parent().global_position.x > 650):
			get_parent().global_position.x = 650
		elif(get_parent().global_position.x < 150):
			get_parent().global_position.x = 150

func open_build_menu():
	var build_menu = build_menu_scene.instance()
	get_parent().add_child(build_menu)
	build_menu_path = build_menu.get_path()
	print("added: " + build_menu.get_path())

func open_tunnel_menu():
	var build_menu = tunnel_menu_scene.instance()
	get_parent().add_child(build_menu)
	build_menu_path = build_menu.get_path()
	print("added: " + build_menu.get_path())

func open_shop_menu():
	var build_menu = shop_menu_scene.instance()
	get_parent().add_child(build_menu)
	build_menu_path = build_menu.get_path()
	print("added: " + build_menu.get_path())
	
func get_should_open_all():
	var driver = get_parent().get_node("driver")
	return !driver.is_enemy and driver.type == "empty"
	
func get_should_open_shop():
	var driver = get_parent().get_node("driver")
	return !driver.is_enemy and driver.type == "port"

func _button_pressed():
	if not active: return
	# for some reason the button is clicked immediately, probably because we are 
	# adding it on the same frame and the mouse is already down. This is fine, 
	# but if the menu stops opening, it is probably because this became too slow.
	if get_should_open_all():
		var build_menu = get_menu()
		if build_menu == null or !is_instance_valid(build_menu):
			open_build_menu()
	elif get_should_open_shop():
		var build_menu = get_menu()
		if build_menu == null or !is_instance_valid(build_menu):
			open_shop_menu()
	else:
		var build_menu = get_menu()
		if build_menu == null or !is_instance_valid(build_menu):
			open_tunnel_menu()
	
func get_menu():
	if build_menu_path == null:
		return null
	return get_node_or_null(build_menu_path)

func _input(event):
	if event is InputEventMouseButton:
		var build_menu = get_menu()
		if build_menu != null and is_instance_valid(build_menu) and event.button_index != 1: # not left click
			build_menu.remove()
			build_menu_path = null
	# todo: hide when mouse gets too far away
