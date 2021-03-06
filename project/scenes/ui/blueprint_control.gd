extends Area2D

var old_modulate = null
var bad_modulate = Color(1,0,0)

var can_place = false
var origin = null

var max_length = 450

# Called when the node enters the scene tree for the first time.
func _ready():
	var line = get_parent().get_node("Line")
	line.points[0] = position
	line.points[1] = position
	line.visible = false

func set_bad_mod():
	if old_modulate == null:
		old_modulate = get_node("Sprite").modulate
	get_node("Sprite").modulate = bad_modulate
	
func reset_mod():
	get_node("Sprite").modulate = old_modulate

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(len(get_overlapping_areas()))
	if len(get_overlapping_areas()) > 0:
		set_bad_mod()
		can_place = false
	elif old_modulate != null:
		reset_mod()
		can_place = true
	else:
		can_place = true
	var line = get_parent().get_node("Line")
	if origin != null:
		line.points[0] = origin.position
		line.points[1] = position
		line.visible = true
		if can_place and position.distance_to(origin.position) > max_length:
			set_bad_mod()
			can_place = false
		

func build():
	# todo: cancel blueprints on game over
	if can_place:
		var baseController = get_parent().get_parent().get_node("baseController")
		if baseController == null:
			print_debug("Something went wrong cancelling a blueprint!")
		else:
			baseController.create_building(origin, global_position)
		get_parent().queue_free()
		get_node("/root/Game/Static/audio").play_sfx("place")
	else:
		get_node("/root/Game/Static/audio").play_sfx("cancel")
		cancel()
	origin.get_node("driver").active_blueprint = null
	
func cancel():
	var baseController = get_parent().get_parent().get_node("baseController")
	if baseController == null:
		print_debug("Something went wrong cancelling a blueprint!")
	else:
		baseController.submit_trade(0,0,0,0,100)
	get_parent().queue_free()
	origin.get_node("driver").active_blueprint = null

func _input(event):
	if event is InputEventMouseMotion:
		global_position = event.position
	if event is InputEventMouseButton:
		if event.button_index == 1: # left click
			build()
		elif event.button_index == 2: # right click
			cancel()

