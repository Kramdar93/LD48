extends Area2D

var old_modulate = null
var bad_modulate = Color(1,0,0)

var can_place = false
var origin = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(len(get_overlapping_areas()))
	if len(get_overlapping_areas()) > 0:
		if old_modulate == null:
			old_modulate = get_node("Sprite").modulate
		get_node("Sprite").modulate = bad_modulate
		can_place = false
	elif old_modulate != null:
		get_node("Sprite").modulate = old_modulate
		can_place = true
	else:
		can_place = true
	var line = get_parent().get_node("Line")
	if origin != null:
		line.points[0] = origin.position
		line.points[1] = position
		

func build():
	if can_place:
		get_parent().get_parent().get_node("baseController").create_building(origin, global_position)
		get_parent().queue_free()
	else:
		cancel()
	
func cancel():
	get_parent().queue_free()

func _input(event):
	if event is InputEventMouseMotion:
		global_position = event.position
	if event is InputEventMouseButton:
		if event.button_index == 1: # left click
			build()
		else: # idc
			cancel()

