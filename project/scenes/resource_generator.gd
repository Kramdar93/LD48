extends Node2D

# generates resources dynamically in screen-sized chunks

export (PackedScene) var base_resource

var generated_chunks = {}

const height = 600
const width = 800

# Called when the node enters the scene tree for the first time.
func _ready():
	# generate initial chunk and surrounding
	_process(0)
	
func get_max_resource_amount_by_depth(depth):
	return 5
	
func get_min_resource_amount_by_depth(depth):
	return 1
	
func get_max_number_of_deposits_by_depth(depth):
	return 10
	
func get_min_number_of_deposits_by_depth(depth):
	return 1

func get_bounded_randi(bottom, top):
	if bottom > top:
		var temp = top
		top = bottom
		bottom = temp
	return (randi() % int(top - bottom)) + bottom
	
func get_random_type_by_depth(depth):
	var oxy_weight = 1
	var water_weight = 1
	var food_weight = 1
	var mineral_weight = 1
	# todo: make these all change a bit
	var oxy_limit = oxy_weight
	var water_limit = oxy_limit + water_weight
	var food_limit = water_limit + food_weight
	var total = food_limit + mineral_weight
	var randy = randi() % total
	if randy < oxy_limit:
		return "oxygen"
	elif randy < water_limit:
		return "water"
	elif randy < food_limit:
		return "food"
	else:
		return "mineral"

func generate_chunk(x,y):
	var startX = x * width
	var endX = startX+width
	var startY = y * height
	var endY = startY+height
	var num_deposits = get_bounded_randi(get_min_number_of_deposits_by_depth(y),get_max_number_of_deposits_by_depth(y))
	for i in range(num_deposits):
		var deposit_value = get_bounded_randi(get_min_resource_amount_by_depth(y),get_max_resource_amount_by_depth(y))
		var type = get_random_type_by_depth(y)
		var newX = get_bounded_randi(startX,endX)
		var newY = get_bounded_randi(startY,endY)
		var new_deposit = base_resource.instance()
		new_deposit.position.x = newX
		new_deposit.position.y = newY
		new_deposit.type = type
		new_deposit.amount = deposit_value
		get_parent().get_node("resources").add_child(new_deposit)

func _process(delta):
	# these are negative since the ground is 'moving' right when the camera pans left get it?
	var chunkX = -int(global_position.x / width)
	var chunkY = -int(global_position.y / height)
	for i in range(chunkX-1,chunkX+2):
		for j in range(chunkY-1,chunkY+2):
			var chunkKey = str(i)+","+str(j)
			if not generated_chunks.has(chunkKey):
				generate_chunk(i,j)
				generated_chunks[chunkKey] = true
				print("generated chunk " + chunkKey)
