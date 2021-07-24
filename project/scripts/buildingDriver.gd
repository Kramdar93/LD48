extends Node2D


var type = "empty"
var is_enemy = false
var is_active = true

var parent_building = null
var child_buildings = []

var oxygen_store = 0.0
var water_store = 0.0
var food_store = 0.0
var mineral_store = 0.0
var credit_store = 0.0

var sensing_tick_delay = 0.1
var sensing_tick_timer = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func extract_init():
	var overlaps = get_node("sensingArea").get_overlapping_areas() # does not update immediately, but player cannot immediately build improved buildings.
	for area in overlaps:
		var resource = area.get_parent()
		if resource.has_method("get_type"):
			if resource.get_type() == "oxygen":
				oxygen_store += resource.amount
			elif resource.get_type() == "water":
				water_store += resource.amount
			elif resource.get_type() == "food":
				food_store += resource.amount
			elif resource.get_type() == "mineral":
				mineral_store += resource.amount
			elif resource.get_type() == "credit":
				credit_store += resource.amount
			resource.queue_free()	
	get_node("/root/Game/Static/audio").play_sfx("bad")

func _physics_process(delta):
	if not is_active:
		return
	sensing_tick_timer += delta
	if sensing_tick_timer > sensing_tick_delay:
		sensing_tick_timer = 0
		var overlaps = get_node("sensingArea").get_overlapping_areas()
		for area in overlaps:
			var resource = area.get_parent()
			if resource.has_method("get_type"):
				resource.z_index = 0
		

func sensor_init():
	# resize collider!
	get_parent().get_node("light").scale *= 10
	get_node("sensingArea/CollisionShape2D").scale *= 10
	get_node("/root/Game/Static/audio").play_sfx("sensor")
	
# this will likely be non-functional for the compo...
func fortification_init():
	get_node("/root/Game/Static/audio").play_sfx("bad")

func set_type(new_type):
	if type == "empty":
		if new_type == "fortification":
			type = new_type
			get_parent().get_node("sprite").frame = 4
			fortification_init()
		if new_type == "extractor":
			type = new_type
			get_parent().get_node("sprite").frame = 2
			extract_init()
		if new_type == "sensor":
			type = new_type
			get_parent().get_node("sprite").frame = 3
			sensor_init()
		if new_type == "port":
			type = new_type
			get_parent().get_node("sprite").frame = 1
		if new_type == "command":
			type = new_type
			get_parent().get_node("sprite").frame = 8

func kill():
	is_active = false
	get_parent().find_node("sprite").modulate = Color(1,0,0)
	get_parent().find_node("Button").active = false
	for edge in get_parent().find_node("edges").get_children():
		edge.default_color = Color(1,0,0)
	for child in child_buildings:
		child.find_node("driver").kill()
	# hide resources etc
	get_parent().find_node("light").modulate = Color(1,1,1,0)
	var overlaps = get_node("sensingArea").get_overlapping_areas()
	for area in overlaps:
		var resource = area.get_parent()
		if resource.has_method("get_type"):
			resource.z_index = -1000
	# handle hacky stuff
	if type == "command":
		get_parent().find_node("tunnel").default_color = Color(1,0,0)
		get_node("/root/Game/Static/Clock").end_game("dead")
