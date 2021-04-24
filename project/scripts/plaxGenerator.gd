extends Node2D

export var paralax_factor = 1
export var density = 10
export (PackedScene) var item_to_generate = null

const start = -500
const end = 500

# this class sucks... too bad!

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(density):
		makeObj(int(start + i*((end - start)/density)))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func makeObj(x):
	var new_item = item_to_generate.instance()
	new_item.position.y = 0 # relative
	new_item.position.x = x
	new_item.z_index = z_index
	add_child(new_item)

func cullChildren():
	for child in get_children():
		var xdiff = child.position.x # - position.x
		if xdiff > end or xdiff < start:
			if xdiff > end:
				makeObj(xdiff - end + start)
			elif xdiff < start:
				makeObj(xdiff + end - start)
			child.queue_free()
			remove_child(child)

func moveChildren(x):
	var laxed_amount = int(x/paralax_factor)
	for child in get_children():
		child.position.x += laxed_amount
	cullChildren() # you were supposed to be the chosen one!

func _unhandled_input(event):
	if event.is_action_pressed("ui_right"):
		moveChildren(10)
	if event.is_action_pressed("ui_left"):
		moveChildren(-10)
