extends Node2D

export (PackedScene) var base_enemy

var type = "none"

var sensing_tick_delay = 0.1
var sensing_tick_timer = 0
var speed = 2.5
var target = null

var baby_delay = 30.0
var baby_timer = 0
var last_baby = null

var alive = true;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func init():
	z_index = -1000
	if type == "monster":
		get_node("Sprite").frame = 5
	elif type == "nest":
		get_node("Sprite").frame = 13
		plop_monster()

func float_to_base(delta):
	sensing_tick_timer += delta
	if sensing_tick_timer > sensing_tick_delay:
		sensing_tick_timer = 0
		# find buildings that can be attacked right now
		var overlaps = get_node("attackArea").get_overlapping_areas()
		for area in overlaps:
			var building = area.get_parent()
			if building != null and building.has_method("extract_init") and building.is_active:
				handle_attack(building)
		# clear target if it dies
		if target != null and not target.is_active:
			target = null
		# find new target
		var mindist
		if target == null:
			mindist = 1000
		else:
			mindist = target.global_position.distance_to(global_position)
		overlaps = get_node("sensingArea").get_overlapping_areas()
		for area in overlaps:
			var building = area.get_parent()
			if building != null and building.has_method("extract_init") and building.is_active and building.type != "port":
				var newdist = building.global_position.distance_to(global_position)
				if newdist < mindist:
					mindist = newdist
					target = building
		if target != null:
			var move = (target.global_position - global_position).normalized() * speed
			global_position += move
	
func plop_monster():
	var new_enemy = base_enemy.instance()
	get_parent().add_child(new_enemy)
	new_enemy.global_position.x = global_position.x
	new_enemy.global_position.y = global_position.y
	new_enemy.type = "monster"
	new_enemy.init()
			
func process_plop(delta):
	if last_baby == null:
		baby_timer += delta
		if baby_timer > baby_delay:
			baby_timer = 0
			plop_monster()

func _physics_process(delta):
	if not alive: return
	if type == "monster":
		float_to_base(delta)
	elif type == "nest":
		process_plop(delta)

func handle_attack(building):
	if(building.type == "fortification"):
		alive = false
		get_node("Sprite").modulate = Color(1,0,0)
		get_node("/root/Game/playerBase/playerBase/baseController").log_kill()
	else:
		building.kill()
	target = null
	

func get_type():
	return type
