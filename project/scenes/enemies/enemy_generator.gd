extends Node2D

# generates enemies dynamically in screen-sized chunks

export (PackedScene) var base_enemy

var generated_chunks = {}

var debug_enabled = true

const height = 600
const width = 800

# Called when the node enters the scene tree for the first time.
#func _ready():
	# generate initial chunk and surrounding
	#_process(0)
	
# NOTE: these should all be lower/ non-linear. I'm leaving them this insane for a shorter playtime.
# it would be better for performance to switch these and have fewer, larger value deposits...
func get_max_enemies_by_depth(depth):
	var slope = 0.2 # 1 @ 5, 2 @ 10, 10 @ 50
	var absolute_min = 0
	return max(int(slope*depth + absolute_min), 0)
	
func get_min_enemies_by_depth(depth):
	var slope = 0.1 # 1 @ 20, 2 @ 30...
	var absolute_min = -1
	return max(int(slope*depth + absolute_min), 0)
	return int(slope*depth + absolute_min)

func get_bounded_randi(bottom, top):
	if bottom == top:
		return bottom
	if bottom > top:
		var temp = top
		top = bottom
		bottom = temp
	return (randi() % int(top - bottom)) + bottom
	
func get_random_type_by_depth(depth):
	var monster_weight = 1
	var nest_weight = 1
	if depth < 15:
		nest_weight = 0
	if depth > 30:
		nest_weight = 2
	var monster_limit = monster_weight
	var total = monster_limit + nest_weight
	var randy = randi() % total
	if randy < monster_limit:
		return "monster"
	else:
		return "nest"

func generate_chunk(x,y):
	var startX = x * width
	var endX = startX+width
	var startY = y * height
	var endY = startY+height
	var num_deposits = get_bounded_randi(get_min_enemies_by_depth(y),get_max_enemies_by_depth(y))
	for i in range(num_deposits):
		gen_enemy(x,y,startX,startY,endX,endY)

func gen_enemy(x,y,startX,startY,endX,endY):
	var type = get_random_type_by_depth(y)
	var newX = get_bounded_randi(startX,endX)
	var newY = get_bounded_randi(startY,endY)
	var new_enemy = base_enemy.instance()
	get_parent().get_node("enemies").add_child(new_enemy)
	new_enemy.position.x = newX
	new_enemy.position.y = newY
	new_enemy.type = type
	new_enemy.init()
	

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


func _input(event):
	if debug_enabled and event.is_action_pressed("ui_accept"):
		gen_enemy(0,0,-400,-300,400,300)
